require_relative '../../../lib/line_request/line_message/element/quick_reply_element.rb'

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
    element = QuickReplyElement.new(message_header)
    separators.map { |sep| element.add_action(action(sep.use_str, sep.id)) }
    LineMessage.build_by_quick_reply(element)
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

  def action(sep_str, sep_id)
    {
      "type": 'postback',
      "label": sep_str,
      "data": "action=set_separator&separator_id=#{sep_id}"
    }
  end
end
