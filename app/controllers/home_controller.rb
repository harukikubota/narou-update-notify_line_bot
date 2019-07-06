class HomeController < ApplicationController

  # GET /
  def index
    render json: {"text": "hello"}
  end

  # POST /
  def callback
    request_info = proc_request

    user_info = request_info.user_info
    @user = User.find_or_create(user_info.line_id)

    command = CommandFactory.get_command(request_info.type, user_info, request_info)
    command.call

    if command.success?
      binding.pry
      res = @messenger.reply(user_info.reply_token, LineMessege.build_by_single_message(command.message))
      if res.code != '200'
        p res.body
        send_error_message
        head :bad_request
      end
    else
      send_error_message
      head :bad_request
    end
    # case request_info.type
    # when :follow
    #   User.enable_to_user(@user)
    # when :unfollow
    #   User.disable_to_user(@user)
    # when :delete
    #   send_delete(user_info)
    # when :help
    #   send_help(user_info)
    # when :info
    #   send_info(user_info)
    # when :list
    #   send_novel_list(user_info)
    #   #@messenger.reply_carousel(user_info.reply_token)
    # when :line
    #   send_respond_to_communication(user_info)
    # else
    #   send_unsupported(user_info)
    # end
  end

  private

  def send_error_message
    message = "エラーが発生しました。\nタイプ : #{request_info.type}"
    @messenger.reply(user_info.reply_token, LineMessege.build_by_single_message(message))
  end

  # response START ----------------------------------------- #
  def send_delete(user_info)
    @messenger.reply(user_info.reply_token, Constants::REPLY_MESSAGE_DELETE)
  end

  def send_help(user_info)
    @messenger.reply(user_info.reply_token, Constants::REPLY_MESSAGE_HELP)
  end

  def send_info(user_info)
    @messenger.reply(user_info.reply_token, Constants::REPLY_MESSAGE_INFO)
  end

  def send_novel_list(user_info)
    #message = build_novel_list_message
    message = build_novel_list_message_by_carousel
    @messenger.reply(user_info.reply_token, message)
  end

  def send_respond_to_communication(user_info)
    @messenger.reply(user_info.reply_token, 'Hello!')
  end

  def send_unsupported(user_info)
    @messenger.reply(user_info.reply_token, Constants::REPLY_MESSAGE_UNSUPPORTED)
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
