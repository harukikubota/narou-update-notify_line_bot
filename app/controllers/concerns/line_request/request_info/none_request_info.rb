module LineRequest
  class NoneRequestInfo
    attr_reader :identifier
    def initialize(_data)
      @identifier = 'NONE'
    end
  end
end