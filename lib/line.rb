class Line
  require 'line/bot'

  def initialize(request)
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    @event = (client.parse_events_from(body))[0]

    case @event
    when Line::Bot::Event::Message
      case @event.type
       when Line::Bot::Event::MessageType::Text
         @text = @event.message['text']
      end
    end
  end

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

  def request_text
    @text
  end

  def create_user_info
    user_id = @event["source"]["userId"]
    reply_token = @event["replyToken"]
    [
      user_id,
      reply_token
    ]
  end
end