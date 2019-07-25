require_relative '../../../lib/line_request/line_message/element/quick_reply_element.rb'

class ShowNotifyRangeTime < PostbackCommand
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
    notify_times.map { |time| element.add_action(action(string_range_time_to(time.to_range), time.id)) }
    LineMessage.build_by_quick_reply(element)
  end

  def notify_times
    ConfigNotifyTime.order(:id)
  end

  def message_header
    <<~MES.chomp
      現在の通知時間は#{string_range_time_to(now_notify_range_time)}です。
      変更するには下記一覧から選択してください。
    MES
  end

  def action(label, id)
    {
      "type": 'postback',
      "label": label,
      "data": "action=set_notify_range_time&notify_time_id=#{id}"
    }
  end

end
