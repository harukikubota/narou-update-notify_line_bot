require_relative '../../../lib/line_request/line_message/element/button_element.rb'

class NovelAdd < TextCommand
  def initialize(request_info)
    super
  end

  def call
    ncode = @user_send_text.match(Constants::REG_NCODE).to_s
    add_novel(ncode)
  end

  private

  def add_novel(ncode)
    @success = true
    return self && regist_limit_over if regist_limit_over?

    novel = Novel.build_by_ncode(ncode)
    @message =
      if novel&.save
        link_u_to_n(user.id, novel.id) ? reply_already_registered(novel) : reply_created(novel)
      else
        reply_unprocessable_entity
      end
  end

  def regist_limit_over
    @message = reply_regist_limit_over
  end

  def regist_limit_over?
    UserCheckNovel.where(user_id: user.id).count == user.regist_max
  end

  def link_u_to_n(user_id, novel_id)
    UserCheckNovel.link_user_to_novel(user_id, novel_id)
  end

  def reply_created(novel)
    @message = LineMessage.build_by_single_message("「#{novel.title}」を登録しました。")
  end

  def reply_already_registered(novel)
    message_body = <<~MES.chomp
      「#{novel.title}」はすでに登録されています。
      削除しますか？
    MES

    button_ele = ButtonElement.new(message_body, nil, '小説の削除確認')
    message = button_ele
      .add_action(button_action_do_delete(novel.id))
      .add_action(button_action_no_delete)

    LineMessage.build_by_button_message(message)
  end

  def reply_unprocessable_entity
    message = <<~MES.chomp
      登録に失敗しました。
      しばらく時間を置いて再度お願いします。
    MES
    LineMessage.build_by_single_message(message)
  end

  def reply_regist_limit_over
    message = <<~MES.chomp
      登録上限の#{user.regist_max}件を超えています。

      新しく追加するには登録を削除してください。
    MES
    LineMessage.build_by_single_message(message)
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

