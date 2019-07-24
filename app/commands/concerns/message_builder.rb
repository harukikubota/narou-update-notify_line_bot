require_relative '../../../lib/line_request/line_message.rb'

module MessageBuilder
  extend ActiveSupport::Concern
  extend LineMessage
end