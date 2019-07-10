class NovelList < Command
  def initialize(user_info, request_info)
    super
  end

  def call
    @message = Constants::REPLY_MESSAGE_LIST_HEAD
    user.novels.count.zero? ? message += Constants::REPLY_MESSAGE_LIST_NO_ITEM :
      @user.novels.each.with_index(1) { |novel, index| @message += ("\n\n" + index.to_s + '. ' + novel.title) }
    @success = true
  end
end