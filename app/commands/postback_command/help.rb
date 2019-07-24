class Help < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    @message = reply_by_help_name(@params['name'])
    @success = true
  end

  private

  # @params [help_name] novel_list
  # @return [message] ユーザへ通知するメッセージ
  def reply_by_help_name(help_name)
    message = instance_eval("help_#{help_name}")
    LineMessage.build_by_single_message(message)
  end

  # -------------------- メッセージ ----------------------- #
  # 【命名規則】
  #    help_xxxx
  #    1. キャメルケースであること。
  #    2. xxxx には、menu.jsonで指定した name を指定すること。
  # ----------------------------------------------------- #
  def help_novel_list
    <<~MES.chomp
      1. 機能説明
        更新を通知できる小説の一覧を表示します。

      2. 操作方法
        [トップメニュー]
          ⇨[一覧メニュー]
          ⇨[小説一覧]
    MES
  end

  def help_novel_add
    <<~MES.chomp
      1. 機能説明
        更新を通知したい小説を追加します。

      2. 操作方法
        更新を通知したいなろう小説のURLを送信します。
        例：「https://ncode.syosetu.com/n6169dz/」
    MES
  end

  def help_novel_delete
    <<~MES.chomp
      1. 機能説明
        小説の更新通知を解除します。

      2. 操作方法
        ①更新通知を解除したいなろう小説のURLを送信します。
          例：「https://ncode.syosetu.com/n6169dz/」
        ②「削除確認メッセージ」が表示されますので、「削除する」を選択してください。
    MES
  end
end
