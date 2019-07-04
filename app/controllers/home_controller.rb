class HomeController < ApplicationController

  BASE_NAROU_URL = 'ncode.syosetu.com/'
  REG_NCODE = %r!n[0-9]{4}[a-z]{2}!
  REG_NAROU_URL = %r!(http|https)://#{BASE_NAROU_URL}#{REG_NCODE}/!

  include Line

  # GET /
  def index
    render json: {"text": "hello"}
  end

  # POST /
  def callback
    @client = Line.new(request)
    text = client.request_text
    user_info = client.create_user_info
    @user = User.find_or_create(user_info[0])
    req_info = get_request_info(text)

    case req_info.type
    when :add_novel
      message = add_novel(user_info, req.ncode)
      send_add_novel(user_info, message)
    when :help
      send_help(user_info)
    when :list
      send_novel_list(user_info)
    else
      send_unsupported(user_info)
    end
  end

  private

  # response START ----------------------------------------- #
  def send_add_novel(user_info, message)
    @client.reply_message(user_info[1], message)
  end

  def send_help(user_info)
    message = "ヘルプ¥n1. 小説の追加¥n  https://ncode.syosetu.com/n2267be/¥n2.小説の一覧¥n  一覧"
    @client.reply_message(user_info[1], message)
  end

  def send_novel_list(user_info)
    novels = Novel.find_by_user_id(user_info[0])
    message = novels.each.with_object("") do |novel, arr|
      message + novel.title + '¥n'
    end
    @client.reply_message(user_info[1], message)
  end

  def send_unsupported(user_info)
    @client.reply_message(user_info[1], message)
  end
  # response END ------------------------------------------- #

  # response message START --------------------------------- #
  def created(novel)
    "追加しました。¥n#{novel.title}"
  end

  def unprocessable_entity(error)
    "登録に失敗しました。¥n#{error}"
  end
  # response message END ----------------------------------- #

  # BIGINES LOGIC
  def add_novel(user_info, ncode)
    user_id = user_info[0]
    novel = Novel.build_by_ncode(ncode)
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
end
