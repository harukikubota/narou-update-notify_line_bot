class Menu < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    @rich_menu_id = RichMenu.find_by_name(@params['name']).rich_menu_id
    @success = true
  end
end
