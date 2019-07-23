class NovelDelete < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    novel_id = @params['novel_id']
    return self, @success = true if novel_id == '0'

    title = Novel.find(novel_id).title

    if delete_ucn = UserCheckNovel.where(novel_id: novel_id).first
      delete_ucn.destroy
      @message = LineMessage.build_by_single_message(reply_deleted(title))
    else
      @message = LineMessage.build_by_single_message(reply_already_deleted(title))
    end
    @success = true
  end

  def reply_deleted(novel_title)
    <<~MES.chomp
      「#{novel_title}」を削除しました。
    MES
  end

  def reply_already_deleted(novel_title)
    <<~MES.chomp
      「#{novel_title}」はすでに削除されています。
    MES
  end
end