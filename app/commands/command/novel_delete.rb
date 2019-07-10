class NovelDelete < TextCommand
  def initialize(user_info, request_info)
    super
  end

  def call
    novel_id = @request_info.data.match(/[0-9]{1,4}/).to_s
    return @success = true if novel_id == '0'

    title = Novel.find(novel_id).title
    delete_ucn = UserCheckNovel.where(novel_id: novel_id).first
    @message = delete_ucn.nil? ? reply_already_deleted(title) : reply_deleted(title)
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