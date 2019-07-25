require_relative '../../../lib/line_request/line_client.rb'

module CommandCommon
  extend ActiveSupport::Concern
  included do
    def user
      @user ||= User.find_by_line_id(@request_info.user_info.line_id)
    end

    def client
      LineClient.new.client
    end
  end
end