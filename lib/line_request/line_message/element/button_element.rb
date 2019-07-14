class ButtonElement
  attr_reader :text, :title, :alt_text, :actions

  def initialize(text, title = nil, alt_text = nil)
    @actions = []
    @text = text
    @title = title
    @alt_text = alt_text
  end

  def add_action(action)
    @actions.push(action)
    self
  end
end
