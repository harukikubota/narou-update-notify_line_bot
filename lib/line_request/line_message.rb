require_relative './line_message/plane_text.rb'
require_relative './line_message/carousel.rb'

# メッセージの基底クラス
module LineMessege
  extend PlaneText
  extend Carousel
  def debug
    return 'this is debug method.'
  end
end