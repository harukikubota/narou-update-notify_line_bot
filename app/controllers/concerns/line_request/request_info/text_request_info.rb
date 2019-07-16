class TextRequestInfo
  attr_reader :user_send_text, :class_identifier
  def initialize(data)
    @user_send_text = data.message['text']
    @class_identifier = judgement_class_identifier(@user_send_text)
  end

  private

  # @return "HELP"
  def judgement_class_identifier(text)
    pattern_constants = Constants::TextRegexp.constants
    identifier = pattern_constants
      .map { |const| [const, reg_const_get(const)] }
      .select { |_const, pattern| pattern =~ text }
      .map(&:shift).first.to_s

    identifier.blank? ? 'NONE' : identifier
  end

  def reg_const_get(const_name)
    Constants::TextRegexp.const_get(const_name)
  end
end
