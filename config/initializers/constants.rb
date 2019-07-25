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

  NO_OVERRIDE_ERROR = 'no override error'

  module Command
    NO_COMMAND_ERROR = '該当のコマンドがありません'.freeze
    COMMANDS_PAHT = './app/commands/'.freeze
    FOLLOW_COMMAND_PATH = 'follow_command/'.freeze
    NONE_COMMAND_PATH = 'none_command/'
    POSTBACK_COMMAND_PATH = 'postback_command/'
    TEXT_COMMAND_PATH = 'text_command/'
  end

  # テキストの送信に対して、タイプを判定するために使用する。
  #
  # 定数名から呼び出すファイルを決めるため、注意する。
  # HOGE => app/commands/text_command/hoge.rb
  #
  module TextRegexp
    NOVEL_ADD = %r{#{REG_PROTOCOL}://#{BASE_NAROU_URL}#{REG_NCODE}/}.freeze
    WRITER_ADD = %r{#{REG_PROTOCOL}://#{BASE_NAROU_MYPAGE_URL}#{REG_WRITER_ID}/}.freeze
    LINE_REQUEST = /Hello, world/.freeze
  end

  module Reply
    NOT_COMPATIBLE_MESSAGE = '未対応のメッセージです。'.freeze
    HELP_TITLE_DESCRIPTION = '1. 機能説明'.freeze
    HELP_TITLE_OPERATION = '2. 操作方法'.freeze
    REPLY_MESSAGE_LIST_HEAD = '【一覧の表示】'.freeze
    PLEASE_WAIT = '現在未対応です。もうしばらくお待ちください。'.freeze
    SEPARATOR_TIMES = 10
    UNSUPPOERTED_INPUT = '入力された内容では何もすることができません。'.freeze
  end

  module Request
    TYPE_FOLLOW = :follow
    TYPE_POSTBACK = :postback
    TYPE_TEXT = :text
    # None(当てはまるものなし)
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
    TYPE_QUICK_REPLY = 'quickReply'.freeze
  end
end
