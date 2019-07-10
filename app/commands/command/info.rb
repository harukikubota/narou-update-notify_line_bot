class Info < Command
  def initialize(user_info, request_info)
    super
  end

  def call
    regist_max = user.regist_max
    now_regist_count = regist_max - user.novels.count
    @message = reply_info(now_regist_count, regist_max)
    @success = true
  end

  def reply_info(now_regist_count, regist_max)
    <<~MES.chomp
      【インフォメーション】

      【現在の登録数】 #{now_regist_count}
      【登録可能上限】 #{regist_max}

      【Twitter】
      ↓要望、バグなどはこちらまで↓
      https://twitter.com/Maaya_pd
    MES
  end
end
