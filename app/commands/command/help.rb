class Help < TextCommand
  def initialize(user_info, request_info)
    super
  end

  def call
    @message = reply_help
    @success = true
  end

  def reply_help
    <<~MES.chomp
      【ヘルプ】
      1. 小説の追加
        なろうのURLを送信してください。

      2. 小説の一覧
        「一覧」を入力してください。

      3. 小説の削除
        すでに登録しているなろうのURLを送信してください。

      4. インフォメーション
        「インフォメーション」を入力してください
    MES
  end
end