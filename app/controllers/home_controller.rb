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

    case request_info.type
    when :follow
      User.enable_to_user(@user)
    when :unfollow
      User.disable_to_user(@user)
    when :add_novel
      ncode = request_info.user_send_text.match(Constants::REG_NCODE).to_s
      message = add_novel(ncode)
      send_add_novel(user_info, message)
    when :delete
      send_delete(user_info)
    when :help
      send_help(user_info)
    when :info
      send_info(user_info)
    when :list
      send_novel_list(user_info)
      #@messenger.reply_carousel(user_info.reply_token)
    when :line
      send_respond_to_communication(user_info)
    else
      send_unsupported(user_info)
    end
    head :ok
  end

  private

  # response START ----------------------------------------- #
  def send_add_novel(user_info, message)
    @messenger.reply(user_info.reply_token, message)
  end

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
    message = build_novel_list_message
    #message = build_novel_list_message_by_carousel
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
  def created(novel)
    Constants::REPLY_MESSAGE_ADD_CREATE + novel.title
  end

  def unprocessable_entity(model)
    logger.info(model)
    Constants::REPLY_MESSAGE_ADD_FAILURE
  end

  ## Novel List
  def build_novel_list_message
    message = Constants::REPLY_MESSAGE_LIST
    @user.novels.count.zero? ? message += Constants::REPLY_MESSAGE_LIST_NO_NOVEL :
      @user.novels.each.with_index(1) { |novel, index| message += ("\n" + index.to_s + '. ' + novel.title) }
    message
  end
  # response message END ----------------------------------- #

  # BIGINES LOGIC
  def add_novel(ncode)
    novel = Novel.build_by_ncode(ncode)
    message = nil

    if novel&.save
      UserCheckNovel.set_entity(@user.id, novel.id)
      message = created(novel)
    else
      message = unprocessable_entity(novel)
    end
    message
  end

end
