class ApplicationController < ActionController::API

  def created(novel)
    render json: {
      attachments: [{
        color: "#ff6347",
        pretext: "追加しました。",
        text: novel.title
      }]
    },
    status: 201
  end

  def unprocessable_entity(novel)
    message = {
      color: "#dc143c",
      pretext: "登録でエラーが発生しました。",
      text: novel.errors
    }
  end

  def reply_message(text)
    message = {
      type: 'text',
      text: event.message['text']
    }
    client.reply_message(event['replyToken'], message)
  end

  def send_message(user_id, text)
    message = {
      type: 'text',
      text: "メッセージを送信したよ : #{text}"
    }
    client.push_message(user_id, message)
  end
end
