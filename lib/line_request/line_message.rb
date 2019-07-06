require_relative '../line_request/line_message/plane_text.rb'
require_relative '../line_request/line_message/carousel.rb'

# メッセージの基底クラス
class LineMessege
  extend PlaneText
  extend Carousel
end