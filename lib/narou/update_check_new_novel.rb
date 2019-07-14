require_relative '../narou.rb'
require_relative '../line_request/line_messenger.rb'
require_relative '../line_request/line_message/carousel.rb'
require_relative '../line_request/line_message/element/carousel_column.rb'
require_relative '../line_request/line_message/element/carousel_element.rb'

require 'date'

module Narou::UpdateCheckNewNovel extend self

  def batch
    now_hour = DateTime.now.hour
    Constants::CAN_NOTIFY_TIME_RANGE.include?(now_hour) ? UpdateCheckNewNovel.new.run : Rails.logger.info('実行可能時間外')
  end

  class UpdateCheckNewNovel
    include Narou

    def run
      writers = Writer.all
      @something_notify_flag = false
      novel_info = Struct.new(:writer_id, :writer_name, :title, :ncode)

      notify_users_data = writers.each_with_object([]) do |writer, arr|
        if exist_new_novel?(writer)
          novel_count, result = Narou.fetch_writer_episodes_order_new_post(writer.writer_id)
          novels = result.take(novel_count - writer.novel_count).map { |data| novel_info.new(writer.id, writer.name, data['title'], data['ncode'].downcase) }

          writer.update!(
            novel_count: novel_count
          )

          arr << find_update_writer_to_user(novels) && @something_notify_flag = true
        end
      end

      @something_notify_flag ? notify_update_novel_to_user(notify_users_data) : Rails.logger.info('更新はありませんでした。')
    end

    private

    def exist_new_novel?(writer)
      count, _ = Narou.fetch_writer_episodes_order_new_post(writer.writer_id.to_s)
      count > writer.novel_count
    end

    def find_update_writer_to_user(novels)
      notify_element = Struct.new(:user_line_id, :writer_name, :novel_url, :novel_title)
      novel_infos = novels.map { |novel| [novel.writer_name, Narou.narou_url(novel), novel.title] }
      users = User.find_effective_users_in_writer(novels[0].writer_id)
      datas = users.map(&:line_id).product(novel_infos)
      datas.each_with_object([]) { |data, arr| arr << notify_element.new(*data.flatten!) }
    end

    # TODO 更新が６件以上の時エラーになるので変更する
    def notify_update_novel_to_user(users_data)
      users_data.flatten!.group_by(&:user_line_id)
      .each do |user_id, items|
        message_title = build_notify_data(items)
        carousel_ele = carousel_message_template(message_title)
        items.each do |item|
          carousel_ele.add_column(
            column(item.writer_name, item.novel_title)
              .add_action(action(item.novel_url))
          )
        end

        message = Carousel.build_carousel(carousel_ele)

        res = client.send(user_id, message)
        Rails.logger.info('start')
        Rails.logger.info(message)
        Rails.logger.info(res.body)
      end
    end

    def client
      @client ||= LineRequest::LineMessenger.new
    end

    #def build_notify_data(items)
    #  message_title = "#{items.count}件の更新がありました。"
    #  message_body = ""
    #  items.each.with_index(1) { |item, index| message_body += "\n\n##{index}. #{item.novel_title}\n#{item.novel_url}" }
    #  message_title + message_body
    #end

    def build_notify_data(items)
      "#{items.count}件の新規投稿がありました。"
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
