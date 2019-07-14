require_relative '../../../lib/line_request/line_message/element/button_element.rb'

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

      @message = link_user_to_novel(user.id, novel.id) ? reply_already_registered(novel) : reply_created(novel)
    else
      @message = unprocessable_entity
    end
  end

  def regist_limit_over
    @message = reply_regist_limit_over
    @success = true
  end

  def is_regist_limit_over?
    UserCheckNovel.where(user_id: user.id).count == user.regist_max
  end

  def link_user_to_novel(user_id, novel_id)
    UserCheckNovel.link_user_to_novel(user_id, novel_id)
  end

  def reply_created(novel)
    <<~MES.chomp
      「#{novel.title}」を登録しました。
    MES
  end

  def reply_already_registered(novel)
    @message_type = Constants::LineMessage::MessageType::TYPE_BUTTON
    message =<<~MES.chomp
      「#{novel.title}」はすでに登録されています。
      削除しますか？
    MES

    button_ele = ButtonElement.new(message, nil, '小説の削除確認')
    @message = button_ele
      .add_action(button_action_do_delete(novel.id))
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

      新しく追加するには登録を削除してください。
    MES
  end

  def button_action_do_delete(novel_id)
    {
      type: 'postback',
      label: '削除する',
      data: "action=novel_delete&novel_id=#{novel_id}"
    }
  end

  def button_action_no_delete
    {
      type: 'postback',
      label: '削除しない',
      data: 'action=novel_delete&novel_id=0'
    }
  end
end

