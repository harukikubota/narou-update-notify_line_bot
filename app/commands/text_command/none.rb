class None < TextCommand
  def initialize(request_info)
    super
  end

  def call
    @message = LineMessage.build_by_single_message(Constants::Reply::UNSUPPOERTED_INPUT)
    @success = true
  end
end
