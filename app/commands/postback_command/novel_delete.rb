require_relative '../../../lib/line_request/line_message/element/button_element.rb'

class NovelDelete < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    novel_id = @params['novel_id']
    novel = Novel.find(novel_id)

    @message =
      if UserCheckNovel.unlink_user_to_novel(user.id, novel_id)
        reply_deleted(novel)
      else
        reply_already_deleted(novel.title)
      end
    @success = true
  end

  def reply_deleted(novel)
    message_body = <<~MES.chomp
      「#{novel.title}」を削除しました。
      削除を取り消すには下のボタンを押してください。
    MES

    button_ele = ButtonElement.new(message_body, nil, '小説の削除終了')
    button_ele.add_action(button_action_undo_delete(narou_url(novel.ncode)))

    LineMessage.build_by_button_message(button_ele)
  end

  def reply_already_deleted(novel_title)
    message = "「#{novel_title}」はすでに削除されています。"
    LineMessage.build_by_single_message(message)
  end

  def button_action_undo_delete(novel_url)
    {
      type: 'message',
      label: '削除を取り消す',
      text: novel_url
    }
  end
end
