require_relative '../../lib/line_accessor.rb'
require 'line/bot'

class HomeController < ApplicationController

  BASE_NAROU_URL = 'ncode.syosetu.com/'
  REG_NCODE = %r!n[0-9]{4}[a-z]{2}!
  REG_NAROU_URL = %r!(http|https)://#{BASE_NAROU_URL}#{REG_NCODE}/!

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
      message = add_novel(user_info, req_info.ncode)
      send_add_novel(user_info, message)
    when :help
      send_help(user_info)
    when :list
      send_novel_list(user_info)
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
    message = "【ヘルプ】\n\n1. 小説の追加\n  なろうのURLを送信してください。\n\n2.小説の一覧\n  「一覧」を入力してください。"
    @messenger.reply(user_info[1], message)
  end

  def send_novel_list(user_info)
    user = User.find(@user.id)

    message = "【一覧の表示】\n"
    user.novels.each.with_index(1) { |novel, index| message += ("\n" + index.to_s + '. ' + novel.title) }
    @messenger.reply(user_info[1], message)
  end

  def send_unsupported(user_info)
    message = "【案内】\n\n入力された内容では何もすることができません。\n\n操作に困ったら「ヘルプ」を入力してください。"
    @messenger.reply(user_info[1], message)
  end
  # response END ------------------------------------------- #

  # response message START --------------------------------- #
  def created(novel)
    "追加しました。\n#{novel.title}"
  end

  def unprocessable_entity(error)
    "登録に失敗しました。\n#{error}"
  end
  # response message END ----------------------------------- #

  # BIGINES LOGIC
  def add_novel(user_info, ncode)
    user_id = user_info[0]
    novel = Novel.build_by_ncode(ncode)
    UserCheckNovel.set_entity(@user.id, novel.id)
    message = nil

    if novel.save
      message = created(novel)
    else
      message = unprocessable_entity(novel)
    end
    message
  end

  def is_narou_url?(url)
    REG_NAROU_URL === url
  end

  def is_help?(text)
    reg = /help|ヘルプ|へるぷ|Help|HELP/
    reg === text
  end

  def is_list?(text)
    reg = /一覧|list/
    reg === text
  end

  def get_request_info(text)
    request_info = Struct.new(:type, :ncode)

    if is_narou_url?(text)
      ncode = text.match(REG_NCODE).to_s
      request_info.new(:add_novel, ncode)
    elsif is_help?(text)
      request_info.new(:help, 'none')
    elsif is_list?(text)
      request_info.new(:list, 'none')
    else
      request_info.new(:none, 'none')
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
