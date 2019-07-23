class Unfollow < FollowCommand
  def initialize(request_info)
    super
  end

  def call
    user.disable_to_user
    @success = true
  end
end
