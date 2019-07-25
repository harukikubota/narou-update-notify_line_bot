module QuickReply
  def build_by_quick_reply(quick_reply_element)
    element = quick_reply_element
    items = element.actions.each_with_object([]) { |action, arr| arr << build_item(action) }
    @text = element&.text

    quick_reply_template(items)
  end

  private

  def type
    Constants::LineMessage::MessageType::TYPE_QUICK_REPLY
  end

  def text
    @text ||= 'this is quickReply message.'
  end

  def build_item(action)
    item = {}

    item[:type] = 'action'
    item[:action] = action

    item
  end

  def quick_reply_template(items)
    {
      "type": 'text',
      "text": text,
      "quickReply": {
        "items": items
      }
    }
  end
end