module LineRequest
  class NoneRequestInfo
    attr_reader :identifier
    def initialize(_request_info)
      @identifier = 'NONE_EVENT'
    end
  end
end