class None < NoneCommand
  def initialize(request_info)
    super
  end

  def call
    @message = LineMessage.build_by_single_message(Constants::Reply::NOT_COMPATIBLE_MESSAGE)
    @success = true
  end
end