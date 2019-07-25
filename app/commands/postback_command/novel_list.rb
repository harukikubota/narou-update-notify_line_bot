class NovelList < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    @message = user.novels.count.zero? ? reply_no_item : reply_registered_list(user.novels)
    @success = true
  end

  private

  def reply_registered_list(novels)
    list = novels.map(&:title)
      .map.with_index(1) { |title, idx| list_row_and_novel(idx, title) }

    message_list = list.inject("") { |str, mes| str += mes }

    message = "#{Constants::Reply::REPLY_MESSAGE_LIST_HEAD}#{message_list}"
    LineMessage.build_by_single_message(message)
  end

  def reply_no_item
    message = <<~MES.chomp
      #{Constants::Reply::REPLY_MESSAGE_LIST_HEAD}

      現在登録しているなろう小説はありません。
      追加するにはなろう小説のURLを送信してください。
    MES
    LineMessage.build_by_single_message(message)
  end

  def list_row_and_novel(index, novel_title)
    "\n\n#{index}. #{novel_title}"
  end
end
