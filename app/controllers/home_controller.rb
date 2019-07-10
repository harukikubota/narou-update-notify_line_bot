class HomeController < ApplicationController

  # GET /
  def index
    render json: {"text": "hello"}
  end

  # POST /
  def callback
    request_info = proc_request
    user_info = request_info.user_info

    command = CommandFactory.get_command(request_info.type, user_info, request_info)
    command.call

    if command.success?
      send_message = build_message(command.message_type, command.message)
      res = @messenger.reply(user_info.reply_token, send_message)
      if res.code != '200'
        p res.body
        fail_execute(user_info.reply_token) if command.message
      else
        head :ok
      end
    else
      fail_execute(user_info.reply_token)
    end
  end

  private

  def send_error_message(reply_token)
    message = Rails.env == 'production' ? 'エラーが発生しました。' : "エラーが発生しました。\nタイプ : #{request_info.type}"
    @messenger.reply(reply_token, LineMessage.build_by_single_message(message))
  end

  def fail_execute(reply_token)
    send_error_message(reply_token)
    head :bad_request
  end

  def build_message(type, message)
    case type
    when Constants::LineMessage::MessageType::TYPE_PLANE
      LineMessage.build_by_single_message(message)
    when Constants::LineMessage::MessageType::TYPE_BUTTON
      LineMessage.build_by_button_message(message)
    # TODO どうするか考える
    when Constants::LineMessage::MessageType::TYPE_CAROUSEL
      LineMessage.build_by_carousel
    end
  end
end
