class LineMessenger
  def initialize
    @client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def reply(reply_token, text)
    message = build_message(text)
    client.reply_message(reply_token, message)
  end

  def send(user_id, text)
    message = build_message(text)
    client.push_message(user_id, message)
  end

  def reply_carousel(reply_token)
    ret = client.reply_message(reply_token, carousel_test)
    Rails.logger.info('start---')
    Rails.logger.info(ret.body)
  end

  def client
    @client
  end

  private

  def build_carousel_with_message(message_text)
    [
      {
        type: 'text',
        text: 'テストです'
      },
      {
        type: 'text',
        text: message_text
      }
    ]
  end

  def carousel_test
    {
      "type": "template",
      "altText": "this is a carousel template",
      "template": {
          "type": "carousel",
          "columns": [
              {
                "title": "this is menu",
                "text": "description",
                "actions": [
                    {
                        "type": "postback",
                        "label": "Buy",
                        "data": "hoge"
                    },
                    {
                        "type": "postback",
                        "label": "Add to cart",
                        "data": "fuga"
                    },
                    {
                        "type": "postback",
                        "label": "View detail",
                        "data": "piyo"
                    }
                ]
              },
              {
                "title": "this is menu",
                "text": "description",
                "actions": [
                  {
                      "type": "postback",
                      "label": "Buy",
                      "data": "hoge"
                  },
                  {
                      "type": "postback",
                      "label": "Add to cart",
                      "data": "fuga"
                  },
                  {
                      "type": "postback",
                      "label": "View detail",
                      "data": "piyo"
                  }
                ]
              }
          ]
      }
    }
  end

  def build_message(message_text)
    {
      type: 'text',
      text: message_text
    }
  end
end