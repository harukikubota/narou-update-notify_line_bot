class PostbackRequestInfo
  attr_reader :action, :params

  def initialize(data)
    pbdatas = (data.postback['data']).split('&')
    @action = pbdatas.shift.split('=')[1]
    @params = pbdatas.map { |val| val.split('=') }.to_h
  end
end
