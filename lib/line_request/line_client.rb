class LineClient
  attr_reader :client
  def initialize
    @client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end

  # @return
  #   [:ok] 処理正常終了
  #   [:bad_message] メッセージにエラーあり
  #   [:api_disconnection] LINEAPIサーバ不通
end