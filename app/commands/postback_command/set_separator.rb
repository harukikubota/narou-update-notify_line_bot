class SetSeparator < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    change_separator
    @message = LineMessage.build_by_single_message(reply_change_completed)
    @success = true
  end

  private

  def change_separator
    user.user_config.change_use_separator(user_specified_separator_id)
  end

  def user_specified_separator_id
    @params['separator_id']
  end

  def reply_change_completed
    "区切り線を「#{now_use_separator}」に変更しました。"
  end
end
