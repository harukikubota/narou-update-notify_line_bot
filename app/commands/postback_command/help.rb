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
      【小説一覧】
      #{Constants::Reply::HELP_TITLE_DESCRIPTION}
        更新を通知できる小説の一覧を表示します。

      #{Constants::Reply::HELP_TITLE_OPERATION}
        [トップメニュー]
          ⇨[一覧メニュー]
          ⇨[小説一覧]
    MES
  end

  def help_novel_add
    <<~MES.chomp
      【小説追加】
      #{Constants::Reply::HELP_TITLE_DESCRIPTION}
        更新を通知したい小説を追加します。

      #{Constants::Reply::HELP_TITLE_OPERATION}
        更新を通知したいなろう小説のURLを送信します。
        例：「#{Constants::NAROU_NOVEL_URL}n6169dz/」
    MES
  end

  def help_novel_delete
    <<~MES.chomp
      【小説削除】
      #{Constants::Reply::HELP_TITLE_DESCRIPTION}
        小説の更新通知を解除します。

      #{Constants::Reply::HELP_TITLE_OPERATION}
        ①更新通知を解除したいなろう小説のURLを送信します。
          例：「#{Constants::NAROU_NOVEL_URL}n6169dz/」
        ②「削除確認メッセージ」が表示されますので、「削除する」を選択してください。
    MES
  end

  def help_writer_list
    <<~MES.chomp
      【作者一覧】
      #{Constants::Reply::HELP_TITLE_DESCRIPTION}
        更新を通知できる作者の一覧を表示します。

      #{Constants::Reply::HELP_TITLE_OPERATION}
        [トップメニュー]
          ⇨[一覧メニュー]
          ⇨[作者一覧]
    MES
  end

  def help_writer_add
    <<~MES.chomp
      【作者追加】
      #{Constants::Reply::HELP_TITLE_DESCRIPTION}
        更新を通知したい作者を追加します。

      #{Constants::Reply::HELP_TITLE_OPERATION}
        更新を通知したいなろう作者のマイページURLを送信します。
        例：「#{Constants::NAROU_MYPAGE_URL}474038/」
    MES
  end

  def help_writer_delete
    <<~MES.chomp
      【作者削除】
      #{Constants::Reply::HELP_TITLE_DESCRIPTION}
        作者の更新通知を解除します。

      #{Constants::Reply::HELP_TITLE_OPERATION}
        ①更新通知を解除したいなろう作者のマイページURLを送信します。
          例：「#{Constants::NAROU_MYPAGE_URL}474038/」
        ②「削除確認メッセージ」が表示されますので、「削除する」を選択してください。
    MES
  end

  def help_separator
    <<~MES.chomp
      【区切り線】
      #{Constants::Reply::HELP_TITLE_DESCRIPTION}
        通知の合間、メモなどに使用できる区切り線を表示します。

      #{Constants::Reply::HELP_TITLE_OPERATION}
        [トップメニュー]
          ⇨[区切り線]
    MES
  end

  def help_infomartion
    <<~MES.chomp
      【インフォメーション】
      #{Constants::Reply::HELP_TITLE_DESCRIPTION}
        登録上限の確認、各種問い合わせを行えます。

      #{Constants::Reply::HELP_TITLE_OPERATION}
        [トップメニュー]
          ⇨[インフォメーション]
    MES
  end

  def help_config
    <<~MES.chomp
      【設定】
      #{Constants::Reply::HELP_TITLE_DESCRIPTION}
        各種設定の確認、変更が行えます。

      #{Constants::Reply::HELP_TITLE_OPERATION}
        [トップメニュー]
          ⇨[設定]
    MES
  end
end
