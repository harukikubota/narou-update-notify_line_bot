class NovelDelete < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    novel_id = @params['novel_id']
    return self && @success = true if novel_id == '0'

    title = Novel.find(novel_id).title

    @message =
      if UserCheckNovel.unlink_user_to_novel(novel_id, user.id)
        LineMessage.build_by_single_message(reply_deleted(title))
      else
        LineMessage.build_by_single_message(reply_already_deleted(title))
      end
    @success = true
  end

  def reply_deleted(novel_title)
    "「#{novel_title}」を削除しました。"
  end

  def reply_already_deleted(novel_title)
    "「#{novel_title}」はすでに削除されています。"
  end
end
