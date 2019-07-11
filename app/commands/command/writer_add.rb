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

      if UserCheckWriter.link_user_to_writer(user.id, writer.id)
        struct = Struct.new(:text, :writer_id)
        message = reply_already_registered_and_delete_confirm(writer)

        @message = struct.new(message, writer.id)
      else
        @message = reply_created(writer)
      end
    else
      @message = unprocessable_entity
    end
  end

  def regist_limit_over
    @message = reply_regist_limit_over
    @success = true
  end

  # TODO 定数切る
  def is_regist_limit_over?
    UserCheckWriter.where(user_id: user.id).count == 15
  end

  def reply_created(writer)
    <<~MES.chomp
      「#{writer.name}」さんの新規投稿監視を登録しました。
    MES
  end

  def reply_already_registered_and_delete_confirm(writer)
    @message_type = Constants::LineMessage::MessageType::TYPE_BUTTON
    <<~MES.chomp
      「#{writer.name}」さんの新規投稿監視ははすでに登録されています。
      削除しますか？
    MES
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
end

