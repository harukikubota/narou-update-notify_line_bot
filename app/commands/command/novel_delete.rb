class NovelDelete < Command
  def initialize(user_info, request_info)
    super
  end

  def call
    @message = Constants::REPLY_MESSAGE_DELETE
    @success = true
  end
end