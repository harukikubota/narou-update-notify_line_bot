module LineRequest
  class PostbackRequestInfo
    attr_reader :identifier, :params

    def initialize(data)
      pbdatas = (data['postback']['data']).split('&')
      action = pbdatas.shift.split('=')[1]
      @identifier = action.upcase
      @params = pbdatas.map { |val| val.split('=') }.to_h
    end
  end
end