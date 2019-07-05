require_relative '../../lib/line_accessor.rb'
require 'line/bot'

class HomeController < ApplicationController

  # GET /
  def index
    render json: {"text": "hello"}
  end

  # POST /
  def callback
    body = request.body.read

    @messenger = LineAccessor.new
    @client = @messenger.client

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless @client.validate_signature(body, signature)
      head :bad_request
    end

    @event = (@client.parse_events_from(body))[0]
    case @event
    when Line::Bot::Event::Message
      case @event.type
       when Line::Bot::Event::MessageType::Text
         @text = @event.message['text']
      end
    end

    user_info = create_user_info
    @user = User.find_or_create(user_info[0])
    req_info = get_request_info(@text)

    case req_info.type
    when :add_novel
      ncode = @text.match(Constants::REG_NCODE).to_s
      message = add_novel(user_info, ncode)
      send_add_novel(user_info, message)
    when :help
      send_help(user_info)
    when :list
      send_novel_list(user_info)
    when :line
      @messenger.reply(user_info[1], 'Hello!')
    else
      send_unsupported(user_info)
    end
    head :ok
  end

  private

  # response START ----------------------------------------- #
  def send_add_novel(user_info, message)
    @messenger.reply(user_info[1], message)
  end

  def send_help(user_info)
    @messenger.reply(user_info[1], Constants::REPLY_MESSAGE_HELP)
  end

  def send_novel_list(user_info)
    user = User.find(@user.id)
    message = Constants::REPLY_MESSAGE_LIST
    user.novels.each.with_index(1) { |novel, index| message += ("\n" + index.to_s + '. ' + novel.title) }
    @messenger.reply(user_info[1], message)
  end

  def send_unsupported(user_info)
    @messenger.reply(user_info[1], Constants::REPLY_MESSAGE_UNSUPPORTED)
  end
  # response END ------------------------------------------- #

  # response message START --------------------------------- #
  def created(novel)
    Constants::REPLY_MESSAGE_ADD_CREATE + novel.title
  end

  def unprocessable_entity(model)
    logger.info(model)
    Constants::REPLY_MESSAGE_ADD_FAILURE
  end
  # response message END ----------------------------------- #

  # BIGINES LOGIC
  def add_novel(user_info, ncode)
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

  def get_request_info(text)
    request_info = Struct.new(:type)

    case text
    when Constants::REG_LINE_REQUEST_MESSAGE
      request_info.new(Constants::Request::TYPE_LINE_REQUEST)
    when Constants::REG_NAROU_URL
      request_info.new(Constants::Request::TYPE_ADD_NOVEL)
    when Constants::REG_HELP_COMMAND
      request_info.new(Constants::Request::TYPE_HELP)
    when Constants::REG_LIST_COMMAND
      request_info.new(Constants::Request::TYPE_LIST)
    else
      request_info.new(Constants::Request::TYPE_NONE)
    end
  end

  def create_user_info
    user_id = @event["source"]["userId"]
    reply_token = @event["replyToken"]
    [
      user_id,
      reply_token
    ]
  end

end
