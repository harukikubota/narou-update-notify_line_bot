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
          p '-------------------------------'
          p user_id
          p '-------------------------------'

          case text
          when REGEP_NAROU_URL
            add_novel(text, user_id)
          when 'hoge'
            send_message(text, user_id)
          end
        end
      end
    }

    head :ok
  end

  private

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
