class Menu < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    rich_menu_id = RichMenu.find_by_name(@params['name']).rich_menu_id
    link_menu_to_user(rich_menu_id)
    @success = true
  end

  private

  def link_menu_to_user(rich_menu_id)
    client.link_user_rich_menu(user.line_id, rich_menu_id)
  end
end
