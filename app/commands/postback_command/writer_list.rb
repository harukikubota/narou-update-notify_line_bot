class WriterList < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    @message = user.writers.count.zero? ? reply_no_item : reply_registered_list(user.writers)
    @success = true
  end

  private

  def reply_registered_list(writers)
    list = writers.map(&:name)
      .map.with_index(1) { |name, idx| name_list_with_index(idx, name) }

    message_list = list.inject("") { |str, mes| str += mes }

    message = "#{Constants::Reply::REPLY_MESSAGE_LIST_HEAD}#{message_list}"
    LineMessage.build_by_single_message(message)
  end

  def reply_no_item
    message = <<~MES.chomp
      #{Constants::Reply::REPLY_MESSAGE_LIST_HEAD}

      現在新規投稿監視を登録しているなろう作者はいません。
      追加するにはなろう作者のマイページURLを送信してください。
    MES
    LineMessage.build_by_single_message(message)
  end

  def name_list_with_index(index, name)
    "\n\n#{index}. #{name}"
  end
end
