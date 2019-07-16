require_relative '../../../lib/line_request/line_messenger.rb'

module LineRequest
  extend ActiveSupport::Concern

  def request_type(event)
    event_type = Constants::Request::TYPE_NONE

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
    end

    event_type
  end

  def client
    @client ||= LineMessenger.new.client
  end
end
