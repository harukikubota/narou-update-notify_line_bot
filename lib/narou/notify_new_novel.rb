require_relative '../line_request/line_client.rb'
require_relative '../line_request/line_message.rb'
require_relative '../line_request/line_message/element/carousel_column.rb'
require_relative '../line_request/line_message/element/carousel_element.rb'

module Narou::NotifyNewNovel extend self
  def batch
    NotifyNewNovel.new.run
  end

  class NotifyNewNovel
    def run
      # 通知データを取得
      notify_datas = UserNotifyNovel.build_notify_data(:new_post)
      # ユーザごとに通知
      notify_datas.group_by(&:user_id).each do |user_id, notify_datas_by_one_user|
        user = User.find(user_id)
        notify_update_novel_to_user(user.line_id, notify_datas_by_one_user)
      end

      # 通知したデータを削除
      UserNotifyNovel.destroy(notify_datas.map(&:id))
    end

    private

    # ユーザ一人を対象にメッセージを送信する
    def notify_update_novel_to_user(line_id, notify_datas)
      notify_novel_count = notify_datas.count
      message = notify_datas.each_slice(10).each.with_index(1).map do |notify_data_max_10, index|
        alt_text = "作者新規投稿通知 #{notify_novel_count}件"
        carousel_ele = CarouselElement.new(alt_text)
        columns = build_columns(notify_data_max_10)
        columns.each do |column|
          carousel_ele.add_column(column)
        end
        LineMessage.build_carousel(carousel_ele)
      end

      client.push_message(line_id, message)
    end

    def build_columns(datas)
      datas.map do |data|
        column = CarouselColumn.new(data.title, data.writer_name)
        novel_url = "#{Constants::NAROU_NOVEL_URL}/#{data.ncode}/#{Constants::QUERY_DEFAULT_BROWSER}"
        column.add_action(action(novel_url))
      end
    end

    def action(novel_url)
      {
        "type": 'uri',
        "label": '読む',
        "uri": novel_url
      }
    end

    def client
      @client ||= LineClient.new.client
    end
  end
end
