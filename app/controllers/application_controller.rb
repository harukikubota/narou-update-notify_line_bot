require 'line/bot'
require_relative '../../lib/line_request/line_messenger.rb'
require_relative '../../lib/line_request/line_message.rb'
require_relative '../../lib/line_request/request_info.rb'

class ApplicationController < ActionController::API
  def proc_request
    body = request.body.read

    @messenger = LineRequest::LineMessenger.new
    @message_template
    @client = @messenger.client

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless @client.validate_signature(body, signature)
      head :bad_request
    end

    event = (@client.parse_events_from(body))[0]
    event_type = nil

    case event
    when Line::Bot::Event::Message
      case event.type
       when Line::Bot::Event::MessageType::Text
          event_type = Constants::Request::TYPE_TEXT
      end
    when Line::Bot::Event::Follow
      event_type = Constants::Request::TYPE_FOLLOW
    when Line::Bot::Event::Unfollow
      event_type = Constants::Request::TYPE_UNFOLLOW
    when Line::Bot::Event::Postback
      event_type = Constants::Request::TYPE_POSTBACK
    else
      event_type = Constants::Request::TYPE_NONE
    end

    RequestInfo.new(event_type, event)
  end
end
