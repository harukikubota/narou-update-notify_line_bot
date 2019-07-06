class CarouselElement
  attr_reader :alt_text, :columns

  def initialize(alt_text = nil)
    @columns = []
    @alt_text = alt_text
  end

  def add_column(column)
    @columns.push(column)
  end
end