module ButtonMessage
  def build_by_button_message(button_element)
    @alt_text = button_element.alt_text
    @message_text = button_element.text
    @actions = button_element.actions
    button_template
  end

  private

  def type
    Constants::LineMessage::MessageType::TYPE_BUTTON
  end

  def alt_text
    @alt_text ||= 'this is carousel message.'
  end

  def button_template
    {
      type: 'template',
      altText: alt_text,
      template: {
        type: type,
        text: @message_text,
        actions: @actions
      }
    }
  end
end
