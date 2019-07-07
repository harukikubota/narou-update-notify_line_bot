class Follow < Command
  def initialize(user_info, request_info)
    super
  end

  def call
    if user
      user.enable_to_user
      @message = Constants::REPLY_MESSAGE_FOLLOW_RETURN
    else
      User.create(
        line_id: @user_info.line_id
      )
      @message = REPLY_MESSAGE_FOLLOW_FIRST
    end
    @success = true
  end
end
