class Info < Command
  def initialize(user_info, request_info)
    super
  end

  def call
    #regist_max = user.regist_max
    regist_max = 20
    now_regist_count = regist_max - user.novels.count
    @message = Constants.reply_information(now_regist_count, regist_max)
    @success = true
  end
end
