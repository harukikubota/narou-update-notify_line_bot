class Separator < TextCommand
  def initialize(user_info, request_info)
    super
  end

  def call
    @message = reply_separator
    @success = true
  end

  def reply_separator
    '-' * 20
  end
end