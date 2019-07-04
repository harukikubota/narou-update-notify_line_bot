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
end
