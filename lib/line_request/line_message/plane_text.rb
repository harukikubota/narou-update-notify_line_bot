module PlaneText
  def build_by_single_message(message)
    plane_template(message)
  end

  def build_by_multi_message(messages)
    raise Constants::LineMessage::ERROR_OVER_MAX_SIZE if messages.size > Constants::LineMessage::MAX_SEND_MESSAGE_SIZE

    messages.each_with_object([]) { |mes, arr| arr << plane_template(mes) }
  end

  private

  def plane_template(message_text)
    {
      type: Constants::LineMessage::MessageType::TYPE_PLANE,
      text: message_text
    }
  end
end
