class NovelAdd < TextCommand
  def initialize(user_info, request_info)
    super
  end

  def call
    ncode = @request_info.user_send_text.match(Constants::REG_NCODE).to_s
    add_novel(ncode)
  end

  private

  def add_novel(ncode)
    return self, regist_limit_over if is_regist_limit_over?

    novel = Novel.build_by_ncode(ncode)

    if novel&.save
      @success = true

      if UserCheckNovel.link_user_to_novel(user.id, novel.id)
        struct = Struct.new(:text, :novel_id)
        message = reply_already_registered_and_delete_confirm(novel)

        @message = struct.new(message, novel.id)
      else
        @message = reply_created(novel)
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
    UserCheckNovel.where(user_id: user.id).count == 15
  end

  def reply_created(novel)
    <<~MES.chomp
      「#{novel.title}」を登録しました。
    MES
  end

  def reply_already_registered_and_delete_confirm(novel)
    @message_type = Constants::LineMessage::MessageType::TYPE_BUTTON
    <<~MES.chomp
      「#{novel.title}」はすでに登録されています。
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

      新しく追加するには登録を削除してください。
    MES
  end
end

