module Constants

  # URL
  URL_SEP = '/'.freeze
  BASE_NAROU_URL = 'ncode.syosetu.com/'.freeze
  BASE_NAROU_MYPAGE_URL = 'mypage.syosetu.com/'.freeze
  NAROU_NOVEL_URL = "https://#{BASE_NAROU_URL}".freeze
  NAROU_MYPAGE_URL = "https://#{BASE_NAROU_MYPAGE_URL}"
  NAROU_API_URL = 'https://api.syosetu.com/novelapi/api/'.freeze
  QUERY_DEFAULT_BROWSER = '?openExternalBrowser=1'.freeze

  # NAROU API
  ## ncode を指定する
  NAROU_API_QUERY_FETCH_EPISODE = '?/lim=1&of=t-ga&out=json&ncode='.freeze
  ## writer_id を指定する
  NAROU_API_QUERY_FETCH_WRITER_NEW_EPISODE = '?order=ncodedesc&of=t-n-w&out=json&userid='.freeze
  NAROU_API_SEARCH_RESULT_COUNT = 'allcount'.freeze
  NAROU_API_NOVEL_TITLE = 'title'.freeze
  NAROU_API_NOVEL_EPISODE_COUNT = 'general_all_no'.freeze

  # REGEXP
  REG_NCODE = /n[0-9]{4}[a-z]{1,2}/.freeze
  REG_WRITER_ID = /[0-9]{1,7}/.freeze
  REG_PROTOCOL = /(http[s]{0,1})/.freeze

  # 運用
  ## バッチ
  CAN_NOTIFY_TIME_RANGE = Rails.env == 'production' ? [*7..22] : [*0..23]

  # テキストの送信に対して、タイプを判定するために使用する。
  #
  # 定数名から呼び出すファイルを決めるため、注意する。
  # HOGE => app/commands/text_command/hoge.rb
  #
  module TextRegexp
    NOVEL_ADD = %r{#{REG_PROTOCOL}://#{BASE_NAROU_URL}#{REG_NCODE}/}.freeze
    NOVEL_LIST = /小説一覧/.freeze
    WRITER_ADD = %r{#{REG_PROTOCOL}://#{BASE_NAROU_MYPAGE_URL}#{REG_WRITER_ID}/}.freeze
    WRITER_LIST = /作者一覧/.freeze
    HELP = /help|ヘルプ|へるぷ|Help|HELP/.freeze
    INFO = /インフォメーション|[iI]nformation|バグ|要望|機能/.freeze
    SEPARATOR = /区切/.freeze
    LINE_REQUEST = /Hello, world/.freeze
  end

  module Request
    # Request Type
    TYPE_FOLLOW = :follow
    TYPE_UNFOLLOW = :unfollow

    ## Postback
    ### 暫定版
    TYPE_POSTBACK = :postback
    TYPE_POSTBACK_NOVEL_DELETE = :novel_delete
    TYPE_POSTBACK_WRITER_DELETE = :writer_delete

    ## Text
    ### 暫定でtextを指定する。
    TYPE_TEXT = :text
    TYPE_TEXT_ADD_NOVEL = :novel_add
    TYPE_TEXT_LIST_NOVEL = :novel_list
    TYPE_TEXT_ADD_WRITER = :writer_add
    TYPE_TEXT_LIST_WRITER = :writer_list
    TYPE_TEXT_HELP = :help
    TYPE_TEXT_INFO = :info
    TYPE_TEXT_SEP = :separator
    TYPE_TEXT_LINE_REQUEST = :line
    TYPE_TEXT_DEBUG = :debug

    ## None(当てはまるものなし)
    TYPE_NONE = :none
  end

  module LineMessage
    MAX_SEND_MESSAGE_SIZE = 5

    ERROR_OVER_MAX_SIZE = '応答メッセージの送信可能数を超えています。'
  end

  module LineMessage::MessageType
    TYPE_PLANE = 'text'.freeze
    TYPE_BUTTON = 'buttons'.freeze
    TYPE_CAROUSEL = 'carousel'.freeze
  end
end
