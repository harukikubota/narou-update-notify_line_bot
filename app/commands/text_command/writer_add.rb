require_relative '../../../lib/line_request/line_message/element/button_element.rb'

class WriterAdd < TextCommand
  def initialize(request_info)
    super
  end

  def call
    writer_id = @request_info.data.user_send_text.match(Constants::REG_WRITER_ID).to_s
    add_writer(writer_id)
  end

  private

  def add_writer(writer_id)
    @success = true
    return self && regist_limit_over if regist_limit_over?

    writer = Writer.build_by_writer_id(writer_id)
    @message =
      if writer&.save
        link_u_to_w(user.id, writer.id) ? reply_already_registered(writer) : reply_created(writer)
      else
        unprocessable_entity
      end
  end

  def link_u_to_w(user_id, writer_id)
    UserCheckWriter.link_user_to_writer(user_id, writer_id)
  end

  def regist_limit_over?
    UserCheckWriter.where(user_id: user.id).count == user.regist_max
  end

  def regist_limit_over
    @message = LineMessage.build_by_single_message(reply_regist_limit_over)
  end

  def reply_created(writer)
    @message = LineMessage.build_by_single_message("「#{writer.name}」の新規投稿監視を登録しました。")
  end

  def reply_already_registered(writer)
    message_body = <<~MES.chomp
      「#{writer.name}」の新規投稿監視はすでに登録されています。
      削除しますか？
    MES

    button_ele = ButtonElement.new(message, nil, '作者の削除確認')
    message = button_ele
      .add_action(button_action_do_delete(writer.id))
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

      新しく追加するには新規投稿監視の登録を削除してください。
    MES
    MESLineMessage.build_by_single_message(message)
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

