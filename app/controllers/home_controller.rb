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
      res = @messenger.reply(user_info.reply_token, LineMessege.build_by_single_message(command.message))
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
    message = Rails.env = 'production' ? 'エラーが発生しました。' : "エラーが発生しました。\nタイプ : #{request_info.type}"
    @messenger.reply(reply_token, LineMessege.build_by_single_message(message))
  end

  def fail_execute(reply_token)
    send_error_message(reply_token)
    head :bad_request
  end

  # response START ----------------------------------------- #

  def send_novel_list(user_info)
    #message = build_novel_list_message
    message = build_novel_list_message_by_carousel
    @messenger.reply(user_info.reply_token, message)
  end
  # response END ------------------------------------------- #

  # response message START --------------------------------- #
  ## Add Novel

  ## Novel List
  def build_novel_list_message
    message = Constants::REPLY_MESSAGE_LIST
    @user.novels.count.zero? ? message += Constants::REPLY_MESSAGE_LIST_NO_NOVEL :
      @user.novels.each.with_index(1) { |novel, index| message += ("\n" + index.to_s + '. ' + novel.title) }
    message
  end

  def build_novel_list_message_by_carousel
    if @user.novels.count.zero?
      message = Constants::REPLY_MESSAGE_LIST + Constants::REPLY_MESSAGE_LIST_NO_NOVEL
    else
      @user.novels
    end
  end
  # response message END ----------------------------------- #

  # BIGINES LOGIC


end
