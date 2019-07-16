class FollowRequestInfo
  def initialize(data)
    @follow_flg = data.instance_eval("@src['type']") == 'follow'
    binding.pry
  end

  def follow?
    @follow_flg
  end
end
