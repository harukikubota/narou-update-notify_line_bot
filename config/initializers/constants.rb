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
  REG_DEBUG_COMMAND = /デバッグ|で|[Dd]/.freeze if Rails.env == 'development'
  REG_REPLY_MESSAGE = /REPLY_MESSAGE/.freeze
  REG_LINE_REQUEST_MESSAGE = /Hello, world/.freeze

  # 運用
  ## バッチ
  CAN_NOTIFY_TIME_RANGE = Rails.env == 'production' ? [*7..22] : [*0..23]

  # 応答メッセージ

  ## FOLLOW
  REPLY_MESSAGE_FOLLOW_RETURN = <<~MES.chomp
    お帰りなさい！

    使い方がわからない場合は「ヘルプ」と入力してください！
  MES

  REPLY_MESSAGE_FOLLOW_FIRST_ = <<~MES.chomp
    友だち追加ありがとうございます0x100001
    【使い方説明】
    ①更新監視を登録したいなろう小説の追加
    ⇨なろう小説のURLを送信します。
    例：
    https://ncode.syosetu.com/n2267be/

    ②更新監視に登録されているなろう小説の一覧を表示
    ⇨「一覧」を含むメッセージを送信します。
    例：
    一覧を表示して0x100078

    ③使い方が分からなくなった0x10007C
    ⇨「ヘルプ」を含むメッセージを送信します。
    例：
    ヘルプ0x100099

    使い方は以上になります！
    要望などあれば作者までお願いします(´°v°)/んぴｯ
  MES

  ## UNFOLLOW
  # no message

  ## ADD
  def self.reply_success_novel_add(novel_title)
    <<~MES.chomp
      登録しました。
      #{novel_title}
    MES
  end

  def self.reply_already_registered_novel(novel_title)
    <<~MES.chomp
      すでに登録されています。
      #{novel_title}
    MES
  end

  REPLY_MESSAGE_ADD_FAILURE = <<~MES.chomp
    登録に失敗しました。
    しばらく時間を置いて再度お願いします。
  MES

  REPLY_MESSAGE_ADD_FAILURE_MAX_REGIST = <<~MES.chomp
    "登録可能上限を超えています。

    ・上限について⇨インフォメーション

    ・削除について⇨削除"
  MES

  ## HELP
REPLY_MESSAGE_HELP = <<~MES.chomp
【ヘルプ】
1. 小説の追加
  なろうのURLを送信してください。

2. 小説の一覧
  「一覧」を入力してください。

3. 小説の削除
  「削除」を入力してください。

4. インフォメーション
  「インフォメーション」を入力してください
MES

  ## LIST
  REPLY_MESSAGE_LIST_HEAD = '【一覧の表示】'.freeze
  REPLY_MESSAGE_LIST_NO_ITEM = <<~MES.chomp
    #{REPLY_MESSAGE_LIST_HEAD}

    現在登録しているなろう小説はありません。
  MES

  def reply_list_any_item(items)
    <<~MES.chomp
      #{REPLY_MESSAGE_LIST_HEAD}

      #{items}
    MES
  end

  ## DELETE
  REPLY_MESSAGE_DELETE = <<~MES.chomp
    【登録の削除】

    現在未対応です。
  MES

  ## INFORMATION
  def self.reply_information(now_regist_count, regist_max)
    <<~MES.chomp
      【インフォメーション】

      【現在の登録数】 #{now_regist_count}
      【登録可能上限】 #{regist_max}

      【Twitter】
      ↓要望、バグなどはこちらまで↓
      https://twitter.com/Maaya_pd
    MES
  end

  ## UNSUPPORTED
  REPLY_MESSAGE_UNSUPPORTED = <<~MES.chomp
    【案内】

    入力された内容では何もすることができません。
    操作に困ったら「ヘルプ」を入力してください。
  MES

  module Request
    # Request Type
    ## Follow UnFollow
    TYPE_FOLLOW = :follow
    TYPE_UNFOLLOW = :unfollow

    ## Text
    ### 暫定でtextを指定する。
    TYPE_TEXT = :text
    TYPE_TEXT_ADD_NOVEL = :novel_add
    TYPE_TEXT_LIST = :novel_list
    TYPE_TEXT_DELETE = :novel_delete
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
    TYPE_CAROUSEL = 'carousel'.freeze
  end
end
