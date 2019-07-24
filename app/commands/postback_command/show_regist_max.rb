class ShowRegistMax < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    regist_max = user.regist_max
    novel_count = user.novels.count
    writer_count = user.writers.count
    @message = reply_regist_max(regist_max, novel_count, writer_count)
    @success = true
  end

  def reply_regist_max(regist_max, novel_count, writer_count)
    message = <<~MES.chomp
      【登録可能上限】 #{regist_max}
      【小説登録数】   #{novel_count}
      【作者登録数】   #{writer_count}
    MES
    LineMessage.build_by_single_message(message)
  end
end
