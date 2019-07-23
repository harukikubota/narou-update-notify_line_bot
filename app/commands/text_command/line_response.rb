class LineResponse < TextCommand
  def initialize(request_info)
    super
  end

  def call
    @message = LineMessage.build_by_single_message('Hello! I am NarouUpdateNotifyBot!')
    @success = true
  end
end
