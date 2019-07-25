require_relative './line_message/plane_text.rb'
require_relative './line_message/carousel.rb'
require_relative './line_message/button_message.rb'
require_relative './line_message/quick_reply.rb'

# メッセージの基底クラス
module LineMessage
  extend PlaneText
  extend Carousel
  extend ButtonMessage
  extend QuickReply
end