require_relative '../line_request/line_client.rb'
require_relative '../line_request/line_message.rb'
require_relative '../line_request/line_message/element/carousel_column.rb'
require_relative '../line_request/line_message/element/carousel_element.rb'

module Narou::NotifyUpdateNovel extend self

  def batch
    NotifyUpdateNovel.new.run
  end

  class NotifyUpdateNovel
    def run
      # 通知データを取得
      notify_datas = UserNotifyNovel.build_notify_data(:update_post)
      # ユーザごとに通知
      notify_datas.group_by(&:user_id).each do |user_id, notify_datas_by_one_user|
        user = User.find(user_id)
        notify_update_novel_to_user(user.line_id, notify_datas_by_one_user)
      end

      # 通知したデータを通知済みにする
      UserNotifyNovel.mark_as_notified_to(notify_datas)
    end

    private

    # ユーザ一人を対象にメッセージを送信する
    def notify_update_novel_to_user(line_id, notify_datas)
      messages = notify_datas.each_slice(10).map do |notify_data_max_10|
        bubbles = build_bubbles(notify_data_max_10)
        carousel_template(bubbles, notify_datas.count)
      end
      client.push_message(line_id, messages)
    end

    def build_bubbles(datas)
      datas.map do |data|
        novel_url = "#{Constants::NAROU_NOVEL_URL}#{data.ncode}/#{data.episode_no}/#{Constants::QUERY_DEFAULT_BROWSER}"
        header = header_title(action_do_read(data.title, novel_url))
        body = body_content(data.episode_no)
        notify_message_bubble(header, body)
      end
    end

    # メッセージのヘッダー
    def header_title(action)
      {
        type: 'box',
        layout: 'vertical',
        contents: [
          {
            type: 'button',
            action: action
          }
        ]
      }
    end

    def body_content(novel_episode_id)
      {
        type: 'box',
        layout: 'vertical',
        contents: [
          {
            type: 'text',
            text: "第#{novel_episode_id}話",
            color: '#e3a368',
            align: 'center'
          }
        ]
      }
    end

    # 小説リンクのアクションボタン
    def action_do_read(novel_title, novel_url)
      {
        type: 'uri',
        label: novel_title.slice(0, 40),
        uri: novel_url
      }
    end

    def client
      @client ||= LineClient.new.client
    end

    # 通知メッセージテンプレート １件ごとのバブル
    def notify_message_bubble(header, body)
      {
        type: 'bubble',
        header: header,
        body: body
      }
    end

    # 最大１０個のバブルを指定できるカルーセルテンプレート
    def carousel_template(bubbles, notify_count)
      {
        type: 'flex',
        altText: "小説更新通知 #{notify_count}件",
        contents: {
          type: 'carousel',
          contents: bubbles
        }
      }
    end
  end
end
