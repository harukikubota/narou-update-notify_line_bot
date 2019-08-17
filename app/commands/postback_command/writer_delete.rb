class WriterDelete < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    writer_id = @params['writer_id']

    writer = Writer.find(writer_id)

    @message =
      if UserCheckWriter.unlink_user_to_writer(user.id, writer_id)
        reply_deleted(writer)
      else
        reply_already_deleted(writer.name)
      end
    @success = true
  end

  def reply_deleted(writer)
    message_body = <<~MES.chomp
      「#{writer.name}」の新規投稿監視を削除しました。
      削除を取り消すには下のボタンを押してください。
    MES
    button_ele = ButtonElement.new(message_body, nil, '作者の削除終了')
    button_ele.add_action(button_action_undo_delete(writer_mypage_url(writer.writer_id)))
    LineMessage.build_by_button_message(button_ele)
  end

  def reply_already_deleted(writer_name)
    message = "「#{writer_name}」の新規投稿監視はすでに削除されています。"
    LineMessage.build_by_single_message(message)
  end

  def button_action_undo_delete(writer_url)
    {
      type: 'message',
      label: '削除を取り消す',
      text: writer_url
    }
  end
end
