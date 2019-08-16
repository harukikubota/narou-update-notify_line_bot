class WriterList < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    @message = user.writers.count.zero? ? reply_no_item : reply_registered_list
    @success = true
  end

  private

  def reply_registered_list
    user.writers.each_slice(10).map { |writers| carousel_template(build_bubbles(writers)) }
  end

  def reply_no_item
    message = <<~MES.chomp
      #{Constants::Reply::REPLY_MESSAGE_LIST_HEAD}

      現在新規投稿監視を登録しているなろう作者はいません。
      追加するにはなろう作者のマイページURLを送信してください。
    MES
    LineMessage.build_by_single_message(message)
  end

  def build_bubbles(writers)
    writers.map do |writer|
      writer_plane_url = "#{Constants::NAROU_MYPAGE_URL}#{writer.writer_id}/"
      writer_open_url = "#{writer_plane_url}/#{Constants::QUERY_DEFAULT_BROWSER}"

      header = header_title(action_do_read(writer_open_url), writer.name)
      box_writer_post_count = make_box_writer_post_count(writer.novel_count)
      box_user_regist_novel = make_box_user_regist_novel(writer)
      body = body_content(box_writer_link, box_episode_info)
      footer = footer_button(action_send_narou_link(writer_plane_url))
      message_bubble(header, body, footer)
    end
  end
end
