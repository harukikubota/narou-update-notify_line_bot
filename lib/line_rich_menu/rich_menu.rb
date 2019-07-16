require 'line/bot'
require 'json'
require_relative '../line_request/line_messenger.rb'

def list
  res = client.get_rich_menus
  ret = JSON.parse(res.body)
  ret['richmenus'].map { |item| [item['name'], item['richMenuId']] }
end

def create_rich_menu(rich_menu)
  client.create_rich_menu(rich_menu)
end

def to_json_obj_rich_menu(file_path)
  open(file_path) { |json| JSON.load(json) }
end

def client
  @client ||= LineMessenger.new.client
end

binding.pry
# よしなにする
p 'hoge'