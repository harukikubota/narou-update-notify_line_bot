class Follow < TextCommand
  def initialize(user_info, request_info)
    super
  end

  def call
    # すでに友達登録済？
    if user
      user.enable_to_user
      @message = reply_unblock
    else
      User.create(
        line_id: @user_info.line_id
      )
      @message = reply_add_friend
    end
    @success = true
  end

  def reply_add_friend
    <<~MES.chomp
      友だち追加ありがとうございます0x100001
      【使い方説明】
      ①更新監視を登録したいなろう小説の追加
      ⇨なろう小説のURLを送信します。

      ②更新監視に登録されているなろう小説の一覧を表示
      ⇨「一覧」を含むメッセージを送信します。

      ③使い方が分からなくなった0x10007C
      ⇨「ヘルプ」を含むメッセージを送信します。

      ④情報みたい0x10007A
      ⇨「インフォメーション」または「情報」を含むメッセージを送信します。

      使い方は以上になります！
      要望などあれば作者までお願いします(´°v°)/んぴｯ
    MES
  end

  def reply_unblock
    <<~MES.chomp
      お帰りなさい！

      使い方がわからない場合は「ヘルプ」と入力してください！
    MES
  end
end