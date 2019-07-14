class WriterAdd < TextCommand
  def initialize(user_info, request_info)
    super
  end

  def call
    writer_id = @request_info.user_send_text.match(Constants::REG_WRITER_ID).to_s
    add_writer(writer_id)
  end

  private

  def add_writer(writer_id)
    return self, regist_limit_over if is_regist_limit_over?

    writer = Writer.build_by_writer_id(writer_id)

    if writer&.save
      @success = true

      @message = link_user_to_writer(user.id, writer.id) ? reply_already_registered(writer) : reply_created(writer)
    else
      @message = unprocessable_entity
    end
  end

  def link_user_to_writer(user_id, writer_id)
    UserCheckWriter.link_user_to_writer(user_id, writer_id)
  end

  def regist_limit_over
    @message = reply_regist_limit_over
    @success = true
  end

  def is_regist_limit_over?
    UserCheckWriter.where(user_id: user.id).count == user.regist_max
  end

  def reply_created(writer)
    <<~MES.chomp
      「#{writer.name}」の新規投稿監視を登録しました。
    MES
  end

  def reply_already_registered(writer)
    @message_type = Constants::LineMessage::MessageType::TYPE_BUTTON
    message = <<~MES.chomp
      「#{writer.name}」の新規投稿監視はすでに登録されています。
      削除しますか？
    MES

    button_ele = ButtonElement.new(message, nil, '作者の削除確認')
    @message = button_ele
      .add_action(button_action_do_delete(writer.id))
      .add_action(button_action_no_delete)
  end

  def reply_unprocessable_entity
    <<~MES.chomp
      登録に失敗しました。
      しばらく時間を置いて再度お願いします。
    MES
  end

  def reply_regist_limit_over
    <<~MES.chomp
      登録上限の#{user.regist_max}件を超えています。

      新しく追加するには新規投稿監視の登録を削除してください。
    MES
  end

  def button_action_do_delete(writer_id)
    {
      type: 'postback',
      label: '削除する',
      data: "action=writer_delete&writer_id=#{writer_id}"
    }
  end

  def button_action_no_delete
    {
      type: 'postback',
      label: '削除しない',
      data: 'action=writer_delete&writer_id=0'
    }
  end
end

