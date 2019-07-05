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
  REG_NCODE = %r!n[0-9]{4}[a-z]{2}!.freeze
  REG_NAROU_URL = %r!(http|https)://#{BASE_NAROU_URL}#{REG_NCODE}/!.freeze
  REG_HELP_COMMAND = /help|ヘルプ|へるぷ|Help|HELP/.freeze
  REG_LIST_COMMAND = /一覧|list/.freeze
  REG_REPLY_MESSAGE = /REPLY_MESSAGE/.freeze
  REG_LINE_REQUEST_MESSAGE = /Hello, world/.freeze

  # 運用
  ## JT ７時〜２３時まで
  CAN_NOTIFY_TIME_RANGE = [*1..14, *22..23].freeze

  # 応答メッセージ
  ## MessageBuiler
  # リプライメッセージを作成する。
  # 引数のパターンを含む定数を、宣言順に結合したメッセージにして返す。
  #
  message_build = ->(pattern) { constants.grep(pattern).map { |const| const_get(const) }.inject('') { |message, body| message += body; message } }

  ## ADD
  REPLY_MESSAGE_ADD_CREATE = "追加しました。\n".freeze
  REPLY_MESSAGE_ADD_FAILURE = "登録に失敗しました。\nしばらく時間を置いて再度お願いします。".freeze

  ## HELP
  REPLY_MESSAGE_HELP_HEAD = '【ヘルプ】'.freeze
  REPLY_MESSAGE_HELP_BODY_NOVEL_ADD = "\n\n1. 小説の追加\n  なろうのURLを送信してください。".freeze
  REPLY_MESSAGE_HELP_BODY_NOVEL_LIST = "\n\n2. 小説の一覧\n  「一覧」を入力してください。".freeze
  REPLY_MESSAGE_HELP = REPLY_MESSAGE_HELP_HEAD + message_build.call(/#{REG_REPLY_MESSAGE}_HELP_BODY/).freeze

  ## LIST
  REPLY_MESSAGE_LIST_HEAD = "【一覧の表示】\n".freeze
  REPLY_MESSAGE_LIST_NO_NOVEL = '登録しているなろう小説はありません。'.freeze
  REPLY_MESSAGE_LIST = message_build.call(/#{REG_REPLY_MESSAGE}_LIST_[^N]/).freeze

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
    TYPE_TEXT_HELP = :help
    TYPE_TEXT_LIST = :list
    TYPE_TEXT_LINE_REQUEST = :line
    TYPE_TEXT_NONE = :none
  end

  module Line
    PARAM_USER_ID = ''
  end
end
