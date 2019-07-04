class LineAccessor
  def initialize
    @client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def reply(reply_token, text)
    message = build_message(text)
    client.reply_message(reply_token, message)
  end

  def send(user_id, text)
    message = build_message(text)
    client.push_message(user_id, message)
  end

  def client
    @client
  end

  private
  def build_message(message_text)
    {
      type: 'text',
      text: message_text
    }
  end
end