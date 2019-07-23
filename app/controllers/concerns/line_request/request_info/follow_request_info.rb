module LineRequest
  class FollowRequestInfo
    attr_reader :identifier
    def initialize(data)
      @identifier = data.instance_eval("@src['type']").upcase
    end
  end
end