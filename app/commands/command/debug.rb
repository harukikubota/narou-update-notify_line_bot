class Debug < TextCommand
  def initialize(user_info, request_info)
    super
  end

  def call
    @message = 'this is debug.'
    @success = true
  end
end