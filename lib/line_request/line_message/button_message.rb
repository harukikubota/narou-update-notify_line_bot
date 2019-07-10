module ButtonMessage
  def build_by_button_message(message)
    button_template(message)
  end

  private

  def button_template(message)
    {
      type: 'template',
      altText: '登録の削除',
      template: {
        type: 'buttons',
        text: message.text,
        actions: [
          {
            type: 'postback',
            label: '削除する',
            data: "action=delete&novel_id=#{message.novel_id}"
          },
          {
            type: 'postback',
            label: '削除しない',
            data: 'action=delete&novel_id=0'
          }
        ]
      }
    }
  end
end