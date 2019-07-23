class None < TextCommand
  def initialize(request_info)
    super
  end

  def call
    @message = LineMessage.build_by_single_message('入力された内容では何もすることができません。')
    @success = true
  end
end
