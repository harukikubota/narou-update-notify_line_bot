class CarouselColumn
  attr_reader :title, :text, :actions

  def initialize(text, title = nil)
    @actions = []
    @text = text
    @title = title
  end

  def add_action(action)
    @actions.push(action)
  end
end
