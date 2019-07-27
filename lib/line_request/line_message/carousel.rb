module Carousel
  def build_carousel(carousel_element)
    element = carousel_element
    columns = element.columns.each_with_object([]) { |column, arr| arr << build_column(column) }
    @alt_text = element&.alt_text

    carousel_template(columns)
  end

  private

  def alt_text
    @alt_text ||= 'this is carousel message.'
  end

  def build_column(ele_column)
    column = {}

    column[:title] = ele_column.title if ele_column.title
    column[:text] = ele_column.text
    column[:actions] = ele_column.actions

    column
  end

  def carousel_template(columns)
    {
      "type": 'template',
      "altText": alt_text,
      "template": {
          "type": Constants::LineMessage::MessageType::TYPE_CAROUSEL,
          "columns": columns
      }
    }
  end
end

