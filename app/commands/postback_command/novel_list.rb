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
    # タイトル、作者名、最終更新日(YY/MM/DD)、エピソード数、novel_url(削除送信用、ページ表示用)





    #list = novels.map(&:title).map.with_index(1) { |title, idx| list_row_and_novel(idx, title) }
    #message_list = list.inject("") { |str, mes| str += mes }
    #message = "#{Constants::Reply::REPLY_MESSAGE_LIST_HEAD}#{message_list}"
    #LineMessage.build_by_single_message(message)
  end

  def reply_no_item
    message = <<~MES.chomp
      #{Constants::Reply::REPLY_MESSAGE_LIST_HEAD}

      現在登録しているなろう小説はありません。
      登録するにはなろう小説のURLを送信してください。
    MES
    LineMessage.build_by_single_message(message)
  end

  def build_bubbles(datas)
    datas.map do |data|
      novel_url = "#{Constants::NAROU_NOVEL_URL}/#{data.ncode}/#{data.episode_no}/#{Constants::QUERY_DEFAULT_BROWSER}"
      header = header_title(action_do_read(data.title, novel_url))
      body = body_content(data.episode_no)
      notify_message_bubble(header, body)
    end
  end

  # メッセージのヘッダー
  def header_title(action)
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

  def body_content(novel)
    writer_mypage_url = "#{Constants::NAROU_MYPAGE_URL}#{writer.writer_id}/"
    last_update_date = novel.updated_at.strftime('%y/%m/%d')

    {
      type: 'box',
      layout: 'vertical',
      contents: [
        {
          type: 'button',
          action: {
            type: 'uri',
            label: novel.writer.name,
            uri: "#{writer_mypage_url}#{Constants::QUERY_DEFAULT_BROWSER}"
          }
        },
        {
          type: 'text',
          text: "最終更新日 #{last_update_date}"
        },
        {
          type: 'text',
          text: "第#{novel_episode_id}話",
          color: Constants::MessageStyle::Color::EPISODE_NO
        }
      ]
    }
  end

  # 小説リンクのアクションボタン
  def action_do_read(novel_title, novel_url)
    {
      type: 'uri',
      label: novel_title,
      uri: novel_url
    }
  end

  # メッセージテンプレート １件ごとのバブル
  def message_bubble(header, body)
    {
      type: 'bubble',
      header: header,
      body: body
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
