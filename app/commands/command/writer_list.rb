class WriterList < TextCommand
  REPLY_MESSAGE_LIST_HEAD = '【一覧の表示】'.freeze

  def initialize(user_info, request_info)
    super
  end

  def call
    @message = user.writers.count.zero? ? reply_no_item : reply_registered_list(user.writers)
    @success = true
  end

  def reply_registered_list(writers)
    list = writers.map(&:name)
      .map.with_index(1) { |name, idx| name_list_with_index(idx, name) }

    message_list = list.inject("") { |str, mes| str += mes }

    <<~MES.chomp
      #{REPLY_MESSAGE_LIST_HEAD}#{message_list}
    MES
  end

  def reply_no_item
    <<~MES.chomp
      #{REPLY_MESSAGE_LIST_HEAD}

      現在新規投稿監視を登録しているなろう作者はいません。
      追加するにはなろう作者のマイページURLを送信してください。
    MES
  end

  def name_list_with_index(index, name)
    "\n\n#{index}. #{name}"
  end
end
