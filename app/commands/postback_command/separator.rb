class Separator < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    @message = LineMessage.build_by_single_message(reply_separator)
    @success = true
  end

  def reply_separator
    sep = user.find_user_use_separate
    sep * 20
  end
end
