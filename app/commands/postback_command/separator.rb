class Separator < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    @message = LineMessage.build_by_single_message(reply_separator)
    @success = true
  end

  def reply_separator
    now_use_separator * 10
  end
end
