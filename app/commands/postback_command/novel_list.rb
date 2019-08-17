class NovelList < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    @message = user.novels.count.zero? ? reply_no_item : reply_registered_list
    @success = true
  end

  private

  def reply_registered_list
    user.novels.each_slice(10).map { |novels| carousel_template(build_bubbles(novels)) }
  end

  def reply_no_item
    message = <<~MES.chomp
      #{Constants::Reply::REPLY_MESSAGE_LIST_HEAD}

      現在登録しているなろう小説はありません。
      登録するにはなろう小説のURLを送信してください。
    MES
    LineMessage.build_by_single_message(message)
  end

  def build_bubbles(novels)
    novels.map do |novel|
      novel_plane_url = narou_url(novel.ncode, novel.last_episode_id)
      novel_open_url = narou_url(novel.ncode, novel.last_episode_id, true)
      writer_open_mypage_url = writer_mypage_url(novel.writer.writer_id, true)

      header = header_title(action_do_read(novel_open_url), novel.title)
      box_writer_link = make_box_writer_info(novel.writer.name, writer_open_mypage_url)
      box_episode_info = make_box_episode_info(novel)
      body = body_content(box_writer_link, box_episode_info)
      footer = footer_button(action_send_narou_link(novel_plane_url))
      message_bubble(header, body, footer)
    end
  end

  # ----------------- header ------------------- #
  # メッセージのヘッダー
  def header_title(action, novel_title)
    {
      type: 'box',
      layout: 'vertical',
      contents: [
        {
          type: 'text',
          text: novel_title,
          color: Constants::MessageStyle::Color::URL_LINK
        }
      ],
      action: action
    }
  end

    # 小説リンクのアクションボタン
    def action_do_read(novel_url)
      {
        type: 'uri',
        uri: novel_url
      }
    end
  # ----------------- header ------------------- #

  # ------------------ body -------------------- #
  def body_content(box_writer_link, box_episode_info)
    {
      type: 'box',
      layout: 'vertical',
      contents: [
        box_writer_link,
        box_episode_info
      ]
    }
  end

  def make_box_writer_info(writer_name, writer_mypage_url)
    {
      type: 'box',
      layout: 'vertical',
      contents: [
        {
          type: 'text',
          text: writer_name,
          color: Constants::MessageStyle::Color::URL_LINK,
          align: 'center',
          margin: 'xl'
        }
      ],
      action: {
        type: 'uri',
        uri: writer_mypage_url
      }
    }
  end

  def make_box_episode_info(novel)
    last_update_date = novel.posted_at.strftime('%y/%m/%d')
    {
      type: 'box',
      layout: 'horizontal',
      contents: [
        {
          type: 'text',
          text: "最終更新日 #{last_update_date}",
          align: 'center',
          wrap: true
        },
        {
          type: 'text',
          text: "最新話 #{novel.last_episode_id}",
          color: Constants::MessageStyle::Color::EPISODE_NO,
          align: 'center',
          gravity: 'center'
        }
      ]
    }
  end
  # ------------------ body -------------------- #

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

  def action_send_narou_link(novel_url)
    {
      type: 'message',
      label: '削除する',
      text: novel_url
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
      altText: '登録した小説一覧表示',
      contents: {
        type: 'carousel',
        contents: bubbles
      }
    }
  end
end
