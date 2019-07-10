class LineResponse < TextCommand
  def initialize(user_info, request_info)
    super
  end

  def call
    @message = 'Hello! I am NarouUpdateNotifyBot!'
    @success = true
  end
end
