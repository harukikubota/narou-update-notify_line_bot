require_relative '../narou.rb'
require_relative '../line_request/line_messenger.rb'
require_relative '../line_request/line_message/carousel.rb'
require_relative '../line_request/line_message/element/carousel_column.rb'
require_relative '../line_request/line_message/element/carousel_element.rb'

require 'date'

module Narou::UpdateCheck extend self

  def batch
    now_hour = DateTime.now.hour
    Constants::CAN_NOTIFY_TIME_RANGE.include?(now_hour) ? UpdateCheck.new.run : Rails.logger.info('実行可能時間外')
  end

  class UpdateCheck
    include Narou

    def run
      novels = Novel.all
      @something_notify_flag = false
      notify_users_data = novels.each_with_object([]) do |novel, arr|
        if is_exist_next_episode?(novel)
          novel.update!(
            last_episode_id: Narou.next_episode_id(novel.last_episode_id)
          )
          arr << find_update_novel_to_user(novel) && @something_notify_flag = true
        end
      end

      @something_notify_flag ? notify_update_novel_to_user(notify_users_data) : Rails.logger.info('更新はありませんでした。')
    end

    private

    def is_exist_next_episode?(novel)
      _f, _, episode_id = Narou.fetch_episode(novel.ncode)
      episode_id > novel.last_episode_id
    end

    def find_update_novel_to_user(novel)
      notify_element = Struct.new(:user_line_id, :novel_url, :novel_title)
      novel_url = Narou.narou_url_with_episode_id(novel) + Constants::QUERY_DEFAULT_BROWSER
      users = User.find_effective_users_in_novel(novel.id)

      users.each_with_object([]) do |user, arr|
        arr << notify_element.new(user.line_id, novel_url, novel.title)
      end
    end

    # TODO 更新が11件以上の時エラーになるので変更する
    def notify_update_novel_to_user(users_data)
      users_data.flatten!.group_by(&:user_line_id)
      .each do |user_id, items|
        message_title = build_notify_data(items)
        carousel_ele = carousel_message_template(message_title)
        items.each do |item|
          carousel_ele.add_column(
            column(item.novel_title)
              .add_action(action(item.novel_url))
          )
        end

        message = Carousel.build_carousel(carousel_ele)

        client.send(user_id, message)
      end
    end

    def client
      @client ||= LineRequest::LineMessenger.new
    end

    def build_notify_data(items)
      "#{items.count}件の更新がありました。"
    end

    def text_message_template(message_text)
      {
        type: Constants::LineMessage::MessageType::TYPE_PLANE,
        text: message_text
      }
    end

    def carousel_message_template(alt_text = nil)
      CarouselElement.new(alt_text)
    end

    def column(text, title = nil)
      CarouselColumn.new(text, title)
    end

    def action(novel_url)
      {
        "type": 'uri',
        "label": '読む',
        "uri": novel_url
      }
    end
  end
end
