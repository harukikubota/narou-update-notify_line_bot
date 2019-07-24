require_relative '../../../lib/line_request/line_client.rb'

module Client
  extend ActiveSupport::Concern
  included do
    def client
      LineClient.new.client
    end
  end
end
