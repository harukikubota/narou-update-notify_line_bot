require_relative './line_message'

class LineMessenger
  include LineMessage

  def initialize
    @client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
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