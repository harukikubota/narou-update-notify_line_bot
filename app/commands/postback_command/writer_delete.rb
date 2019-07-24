class WriterDelete < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    writer_id = @params['writer_id']
    return self && @success = true if writer_id == '0'

    name = Writer.find(writer_id).name

    @message =
      if UserCheckWriter.unlink_user_to_writer(writer_id, user.id)
        LineMessage.build_by_single_message(reply_deleted(name))
      else
        LineMessage.build_by_single_message(reply_already_deleted(name))
      end
    @success = true
  end

  def reply_deleted(writer_name)
    "「#{writer_name}」の新規投稿監視を削除しました。"
  end

  def reply_already_deleted(writer_name)
    "「#{writer_name}」の新規投稿監視はすでに削除されています。"
  end
end
