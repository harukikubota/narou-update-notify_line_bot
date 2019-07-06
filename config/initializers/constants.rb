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
  REG_DEBUG_COMMAND = /デバッグ|で|[Dd]/.freeze
  REG_REPLY_MESSAGE = /REPLY_MESSAGE/.freeze
  REG_LINE_REQUEST_MESSAGE = /Hello, world/.freeze

  # 運用
  ## バッチ
  CAN_NOTIFY_TIME_RANGE = Rails.env == 'production' ? [*7..22] : [*0..23]

  # 応答メッセージ
  ## MessageBuild
  # リプライメッセージを作成する。
  # 引数のパターンを含む定数を、宣言順に結合したメッセージにして返す。
  #
  message_build = ->(pattern) {
    constants.grep(pattern)
      .map { |const| const_get(const) }
      .inject('') { |message, body| message += body; message } }

  ## ADD
  REPLY_MESSAGE_ADD_CREATE = "追加しました。\n".freeze
  REPLY_MESSAGE_ADD_FAILURE = "登録に失敗しました。\nしばらく時間を置いて再度お願いします。".freeze
  REPLY_MESSAGE_ADD_FAILURE_MAX_REGIST = "登録可能上限を超えています。\n\n・上限について⇨インフォメーション\n\n削除について⇨削除"

  ## HELP
  REPLY_MESSAGE_HELP_HEAD = '【ヘルプ】'.freeze
  REPLY_MESSAGE_HELP_BODY_NOVEL_ADD = "\n\n1. 小説の追加\n  なろうのURLを送信してください。".freeze
  REPLY_MESSAGE_HELP_BODY_NOVEL_LIST = "\n\n2. 小説の一覧\n  「一覧」を入力してください。".freeze
  REPLY_MESSAGE_HELP = REPLY_MESSAGE_HELP_HEAD + message_build.call(/#{REG_REPLY_MESSAGE}_HELP_BODY/).freeze

  ## LIST
  REPLY_MESSAGE_LIST_HEAD = "【一覧の表示】\n".freeze
  REPLY_MESSAGE_LIST_NO_NOVEL = '登録しているなろう小説はありません。'.freeze
  REPLY_MESSAGE_LIST = message_build.call(/#{REG_REPLY_MESSAGE}_LIST_[^N]/).freeze

  ## DELETE
  REPLY_MESSAGE_DELETE_HEAD = '【登録の削除】'.freeze
  REPLY_MESSAGE_DELETE_BODY_INFO = "\n\n現在未対応です。"
  REPLY_MESSAGE_DELETE = message_build.call(/#{REG_REPLY_MESSAGE}_DELETE_/).freeze

  ## INFORMATION
  REPLY_MESSAGE_INFO_HEAD = '【インフォメーション】'.freeze
  REPLY_MESSAGE_INFO_BODY_NOW_REGIST_COUNT = "\n\n【現在の登録数】"
  REPLY_MESSAGE_INFO_BODY_MAX_REGIST = "\n\n【登録可能上限】"
  REPLY_MESSAGE_INFO_BODY_TWITTER = "\n\n【Twitter】\n↓要望、バグなどはこちらまで↓\nhttps://twitter.com/Maaya_pd"
  REPLY_MESSAGE_INFO = REPLY_MESSAGE_INFO_HEAD + REPLY_MESSAGE_INFO_BODY_TWITTER

  ## UNSUPPORTED
  REPLY_MESSAGE_UNSUPPORTED_HEAD = '【案内】'.freeze
  REPLY_MESSAGE_UNSUPPORTED_BODY_EXPLAIN = "\n\n入力された内容では何もすることができません。".freeze
  REPLY_MESSAGE_UNSUPPORTED_BODY_PERFORM_OPERATION = "\n\n操作に困ったら「ヘルプ」を入力してください。".freeze
  REPLY_MESSAGE_UNSUPPORTED = REPLY_MESSAGE_UNSUPPORTED_HEAD + message_build.call(/#{REG_REPLY_MESSAGE}_UNSUPPORTED_BODY/).freeze

  module Request
    # Request Type
    ## Follow UnFollow
    TYPE_FOLLOW = :follow
    TYPE_UNFOLLOW = :unfollow

    ## Text
    ### 暫定でtextを指定する。
    TYPE_TEXT = :text
    TYPE_TEXT_ADD_NOVEL = :add_novel
    TYPE_TEXT_DELETE = :delete
    TYPE_TEXT_HELP = :help
    TYPE_TEXT_LIST = :list
    TYPE_TEXT_INFO = :info
    TYPE_TEXT_LINE_REQUEST = :line
    TYPE_TEXT_DEBUG = :debug
    TYPE_TEXT_NONE = :none
  end

  module LineMessage
    MAX_SEND_MESSAGE_SIZE = 5

    ERROR_OVER_MAX_SIZE = '応答メッセージの送信可能数を超えています。'
  end

  module LineMessage::MessageType
    TYPE_PLANE = 'text'.freeze
    TYPE_CAROUSEL = 'carousel'.freeze
  end
end
