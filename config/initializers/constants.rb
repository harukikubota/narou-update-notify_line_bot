module Constants

  # URL
  URL_SEP = '/'.freeze
  BASE_NAROU_URL = 'ncode.syosetu.com/'.freeze
  NAROU_NOVEL_URL = "https://#{BASE_NAROU_URL}".freeze
  NAROU_API_URL = 'https://api.syosetu.com/novelapi/api/'.freeze

  # NAROU API
  ## この定数の後に ncode を指定する
  NAROU_API_QUERY_FETCH_EPISODE = '?/lim=1&of=t-ga&out=json&ncode='.freeze
  NAROU_API_SEARCH_RESULT_COUNT = 'allcount'.freeze
  NAROU_API_NOVEL_TITLE = 'title'.freeze
  NAROU_API_NOVEL_EPISODE_COUNT = 'general_all_no'.freeze

  # REGEXP
  REG_NCODE = /n[0-9]{4}[a-z]{1,2}/.freeze
  REG_NAROU_URL = %r{(http|https)://#{BASE_NAROU_URL}#{REG_NCODE}/}.freeze
  REG_HELP_COMMAND = /help|ヘルプ|へるぷ|Help|HELP/.freeze
  REG_LIST_COMMAND = /一覧|list/.freeze
  REG_DELETE_COMMAND = /削除|[Dd]elete/.freeze
  REG_INFO_COMMAND = /インフォメーション|[iI]nformation|バグ|要望|機能/.freeze
  REG_DEBUG_COMMAND = /デバッグ|で/.freeze if Rails.env == 'development'
  REG_REPLY_MESSAGE = /REPLY_MESSAGE/.freeze
  REG_LINE_REQUEST_MESSAGE = /Hello, world/.freeze

  # 運用
  ## バッチ
  CAN_NOTIFY_TIME_RANGE = Rails.env == 'production' ? [*7..22] : [*0..23]

  module Request
    # Request Type
    TYPE_FOLLOW = :follow
    TYPE_UNFOLLOW = :unfollow

    ## Postback
    ### 暫定版
    TYPE_POSTBACK = :postback
    TYPE_POSTBACK_NOVEL_DELETE = :novel_delete

    ## Text
    ### 暫定でtextを指定する。
    TYPE_TEXT = :text
    TYPE_TEXT_ADD_NOVEL = :novel_add
    TYPE_TEXT_LIST = :novel_list
    TYPE_TEXT_HELP = :help
    TYPE_TEXT_INFO = :info
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