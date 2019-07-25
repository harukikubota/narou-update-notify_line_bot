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
    items = notify_times.map do |time|
      label = string_range_time_to(time.to_range)
      item_template(label, time.id)
    end
    message_template(message_header, items)
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

  def item_template(label, id)
    {
      "type": 'action',
      "action": {
        "type": 'postback',
        "label": label,
        "data": "action=set_notify_range_time&notify_time_id=#{id}"
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
