require 'uri'
require 'net/https'

module Slack
  class << self
    def notify(message)
      webhook_url = ENV['SLACK_WEBHOOK_URL']
      uri = URI.parse(webhook_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data(payload: message.to_json)
      http.request(req)
    end

    def message_completion_ob_abnormal_processing(title, text)
      {
        attachments: [
          {
            color: '#ed2f2f',
            pretext: '異常時処理を実行しました。',
            title: title,
            text: text
          }
        ]
      }
    end
  end
end
