class HomeController < ApplicationController
  require 'line/bot'

  REGEP_NAROU_URL = 'https://ncode.syosetu.com/'

  # GET /
  def index
    render json: {"text": "hello"}
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          text = event.message['text']
          user_id = event['source']['userId']

          case text
          when REGEP_NAROU_URL
            add_novel(user_id, text)
          when 'hoge'
            send_message(user_id, text)
          else
            reply_message(event['replyToken'], 'リプライだお')
          end
        end
      end
    }

    head :ok
  end

  private

  def reply_message(reply_token, text)
    message = {
      type: 'text',
      text: text
    }
    client.reply_message(reply_token, message)
  end

  def send_message(user_id, text)
    message = {
      type: 'text',
      text: "メッセージを送信したよ : #{text}"
    }
    client.push_message(user_id, message)
  end

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def add_novel
    novel = Novel.build_by_narou_url(create_params)
    novel.save ? created(novel) : unprocessable_entity(novel)
  end
end
