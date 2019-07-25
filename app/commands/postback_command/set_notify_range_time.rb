class SetNotifyRangeTime < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    change_notify_range_time
    @message = LineMessage.build_by_single_message(reply_change_completed)
    @success = true
  end

  private

  def change_notify_range_time
    UserConfig.update(config_notify_time_id: user_specified_notify_time_id)
  end

  def user_specified_notify_time_id
    @params['notify_time_id']
  end

  def reply_change_completed
    "通知時間を「#{string_range_time_to(now_notify_range_time)}」に変更しました。"
  end
end
