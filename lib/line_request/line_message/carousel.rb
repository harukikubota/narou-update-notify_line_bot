module Carousel
  class << self
    def build_carousel(carousel_element)
      binding.pry
      element = carousel_element
      columns = element.columns.each_with_object([]) { |column, arr| arr << build_column(column) }
      @alt_text = element.alt_text if element.alt_text

      carousel_template(columns)
    end

    private

    def type
      Constants::LineMessage::MessageType::TYPE_CAROUSEL
    end

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
            "type": type,
            "columns": columns
        }
      }
    end
  end
end
