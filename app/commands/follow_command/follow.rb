class Follow < FollowCommand
  def initialize(request_info)
    super
  end

  def call
    # すでに友達登録済？
    @message =
      if user
        user.enable_to_user
        LineMessage.build_by_single_message(reply_unblock)
      else
        User.new_user(@request_info.user_info.line_id)
        LineMessage.build_by_single_message(reply_add_friend)
      end
    @success = true
  end

  def reply_add_friend
    <<~MES.chomp
      友だち追加ありがとうございます
      【使い方説明】
        ①小説の追加
         ⇨なろう小説のURLを送信してください。

        ②作者の追加
          ⇨なろう作者のマイページURLを送信してください。

        ③その他機能
          ⇨メニューから操作を行えます。

      使い方は以上になります！
      要望などあれば問い合わせまでお願いします(´°v°)/んぴｯ
    MES
  end

  def reply_unblock
    <<~MES.chomp
      お帰りなさい！

      使い方がわからない場合は「メニュー」⇨「ヘルプ」から確認してください！
    MES
  end
end
