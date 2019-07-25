class ShowCanUseSeparator < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    @message = create_message
    @success = true
  end

  private

  def create_message
    items = separators.map { |sep| item_template(sep.use_str, sep.id) }
    message_template(message_header, items)
  end

  def separators
    ConfigSeparate.order(:id)
  end

  def message_header
    <<~MES.chomp
      現在の区切り文字は「#{now_use_separator}」です。
      変更するには下記一覧から選択してください。
    MES
  end

  def item_template(sep_str, sep_id)
    {
      "type": 'action',
      "action": {
        "type": 'postback',
        "label": sep_str,
        "data": "action=set_separator&separator_id=#{sep_id}"
      }
    }
  end

  def message_template(text, items)
    {
      "type": 'text',
      "text": text,
      "quickReply": {
        "items": items
      }
    }
  end
end
