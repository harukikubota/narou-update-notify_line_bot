require_relative './line_message/plane_text.rb'
require_relative './line_message/carousel.rb'
require_relative './line_message/button_message.rb'

# メッセージの基底クラス
module LineMessage
  extend PlaneText
  extend Carousel
  extend ButtonMessage
end