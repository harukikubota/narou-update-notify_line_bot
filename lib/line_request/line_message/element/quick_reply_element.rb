class QuickReplyElement
  attr_reader :text, :actions
  def initialize(text = nil)
    @actions = []
    @text = text
  end

  def add_action(action)
    act = action_template.store('action', action)
    @actions.push(act)
  end

  private

  def action_template
    {
      "type": 'action',
      "action": nil
    }
  end
end