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

      header = header_title(action_open_writer_mypage(writer_open_url), writer.name)
      box_writer_post_count = make_box_writer_post_count(writer.novel_count)
      box_user_regist_novel = make_box_user_regist_novel(writer)
      body = body_content(box_writer_post_count, box_user_regist_novel)
      footer = footer_button(action_send_narou_link(writer_plane_url))
      message_bubble(header, body, footer)
    end
  end

  # ----------------- header ------------------- #
  # メッセージのヘッダー
  def header_title(action, writer_name)
    {
      type: 'box',
      layout: 'vertical',
      contents: [
        {
          type: 'text',
          text: writer_name,
          color: Constants::MessageStyle::Color::URL_LINK,
          align: 'center'
        }
      ],
      action: action
    }
  end

    # 作者マイページリンクのアクションボタン
    def action_open_writer_mypage(writer_mypage_url)
      {
        type: 'uri',
        uri: writer_mypage_url
      }
    end
  # ----------------- header ------------------- #

  # ------------------ body -------------------- #
  def body_content(box_writer_post_count, box_user_regist_novel)
    {
      type: 'box',
      layout: 'vertical',
      contents: [
        box_writer_post_count,
        box_user_regist_novel
      ]
    }
  end

  # 投稿数
  def make_box_writer_post_count(novel_count)
    {
      type: 'box',
      layout: 'vertical',
      contents: [
        {
          type: 'text',
          text: "投稿数  #{novel_count}"
        }
      ]
    }
  end

  def make_box_user_regist_novel(writer)
    novels = user.regist_novel_list_by_writer_id(writer.id)
    novel_boxes = novels.map { |novel| make_box_novel(novel) }
    novel_boxes.insert(0, make_box_user_regist_novels_header(novel_boxes.count))

    {
      type: 'box',
      layout: 'vertical',
      contents: novel_boxes
    }
  end

  def make_box_user_regist_novels_header(novel_count)
    {
      type: 'box',
      layout: 'vertical',
      contents: [
        {
          type: 'text',
          text: "登録している小説 #{novel_count}件"
        }
      ]
    }
  end

  # 小説リンクを作成する
  def make_box_novel(novel)
    {
      type: 'box',
      layout: 'vertical',
      contents: [
        {
          type: 'text',
          text: "・ #{novel.title}",
          color: Constants::MessageStyle::Color::URL_LINK,
          align: 'center'
        }
      ],
      action: {
        type: 'uri',
        uri: narou_url(novel.ncode, novel.last_episode_id, true)
      }
    }
  end

  # ----------------- footer ------------------- #
  def footer_button(action)
    {
      type: 'box',
      layout: 'vertical',
      contents: [
        {
          type: 'button',
          action: action
        }
      ]
    }
  end

  def action_send_narou_link(writer_url)
    {
      type: 'message',
      label: '削除する',
      text: writer_url
    }
  end
  # ----------------- footer ------------------- #

  # ----------------- styles ------------------- #
  def styles
    {
      body: separator_config,
      footer: separator_config
    }
  end

  def separator_config
    {
      separator: true,
      separatorColor: Constants::MessageStyle::Color::SEPARATOR
    }
  end
  # ----------------- styles ------------------- #

  # メッセージテンプレート １件ごとのバブル
  def message_bubble(header, body, footer)
    {
      type: 'bubble',
      header: header,
      body: body,
      footer: footer,
      styles: styles
    }
  end

  # 最大１０個のバブルを指定できるカルーセルテンプレート
  def carousel_template(bubbles)
    {
      type: 'flex',
      altText: '登録した作者一覧表示',
      contents: {
        type: 'carousel',
        contents: bubbles
      }
    }
  end
end
