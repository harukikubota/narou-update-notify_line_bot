class None < Command
  def initialize(user_info, request_info)
    super
  end

  def call
    @message = Constants::REPLY_MESSAGE_UNSUPPORTED
    @success = true
  end
end