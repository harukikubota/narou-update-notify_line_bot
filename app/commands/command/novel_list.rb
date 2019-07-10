class NovelList < Command
  REPLY_MESSAGE_LIST_HEAD = '【一覧の表示】'.freeze

  def initialize(user_info, request_info)
    super
  end

  def call
    @message = user.novels.count.zero? ? reply_no_item : reply_registered_list(user.novels)

    @success = true
  end

  def reply_registered_list(novels)
    list = novels.map(&:title)
      .map.with_index(1) { |title, idx| list_row_novel(idx, title) }

    message_list = list.inject("") { |str, mes| str += mes }

    <<~MES.chomp
      #{REPLY_MESSAGE_LIST_HEAD}#{message_list}
    MES
  end

  def reply_no_item
    <<~MES.chomp
      #{REPLY_MESSAGE_LIST_HEAD}

      現在登録しているなろう小説はありません。
      追加するにはなろう小説のURLを送信してください。
    MES
  end

  def list_row_novel(index, novel_title)
    "\n\n#{index}. #{novel_title}"
  end
end
