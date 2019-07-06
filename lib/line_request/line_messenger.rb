class LineMessenger
  def initialize
    @client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def reply(reply_token, message)
    client.reply_message(reply_token, message)
  end

  def send(user_id, message)
    client.push_message(user_id, message)
  end

  def client
    @client
  end
end