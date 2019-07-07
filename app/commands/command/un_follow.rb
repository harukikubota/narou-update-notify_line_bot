class UnFollow < Command
  def initialize(user_info, request_info)
    super
  end

  def call
    user.disable_to_user
    @success = true
  end
end
