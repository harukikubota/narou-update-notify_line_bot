class NovelList < Command
  def initialize(user_info, request_info)
    super
  end

  def call
    @message = '一覧'
    @success = true
  end
end