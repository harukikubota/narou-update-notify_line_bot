class None < NoneCommand
  def initialize(request_info)
    super
  end

  def call
    @message = LineMessage.build_by_single_message('未対応のメッセージです。')
    @success = true
  end
end