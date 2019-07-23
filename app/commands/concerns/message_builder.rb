require_relative '../../../lib/line_request/line_message.rb'
require_relative '../../../lib/line_request/line_message/element/button_element.rb'
require_relative '../../../lib/line_request/line_message/element/carousel_column.rb'
require_relative '../../../lib/line_request/line_message/element/carousel_element.rb'

module MessageBuilder
  extend ActiveSupport::Concerns
  extend LineMessage

  def button_element
    ButtonElement
  end

  def carousel_column
    CarouselColumn
  end

  def carousel_element
    CarouselElement
  end
end