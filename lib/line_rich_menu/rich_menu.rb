require 'line/bot'
require 'json'
require_relative '../line_request/line_client.rb'

def list
  res = client.get_rich_menus
  ret = JSON.parse(res.body)
  menus = ret['richmenus'].map { |item| [item['name'], item['richMenuId']] }
  menus.each.with_index(1) {|(name, id), index| p "#{index}. #{name}: #{id}" }
  nil
end

def create_rich_menu(rich_menu_obj, name, attribute)
  res = client.create_rich_menu(rich_menu_obj)
  rich_menu_id = res.body.scan(/(richmenu-\w+)/)[0][0]
  create(rich_menu_id, name, attribute)
end

def to_json_obj_rich_menu(json_file_name)
  open(data_path + json_file_name) { |json| JSON.load(json) }
end

def to_image_obj_rich_menu(image_name)
  open(image_path + image_name)
end

def client
  @client ||= LineClient.new.client
end

def create(rich_menu_id, name, attribute)
  RichMenu.create(
    rich_menu_id: rich_menu_id,
    name: name,
    menu_attribute: attribute
  )
end

def data_path
  './rich_menu/data/'
end

def image_path
  './rich_menu/image/menu/'
end

def hlp(type = :all)
  case type
  when :all
    show_help_all
  when :cl
    show_help_client
  when :my
    show_help_my_commands
  else
    p '指定した識別子はありません。'
    p ':all, :cl, :my'
    nil
  end
end

def show_help_all
  show_help_client + show_help_my_commands
end

def show_help_client
  p '## 【Client】 ##'
  p 'リッチメニューの画像をアップロードする'
  p 'client.create_rich_menu_image(<richMenuId>, <file>)'
  p 'リッチメニューを削除する'
  p '  client.delete_rich_menu(<richMenuId>)'
  p 'デフォルトのリッチメニューを設定する'
  p '  client.set_default_rich_menu(<richMenuId>)'
  p 'リッチメニューとユーザーをリンクする'
  p '  client.link_user_rich_menu(<userId>, <richMenuId>)'
end

def show_help_my_commands
  p '## 【MyCommands】 ##'
  p 'リッチメニューの一覧'
  p '  list'
  p 'リッチメニューの作成'
  p '  create_rich_menu(rich_menu_obj, name, attribute)'
  p 'JSONデータを取得する'
  p '  to_json_obj_rich_menu(json_file_name)'
  p 'imageデータを取得する'
  p '  to_image_obj_rich_menu(image_name)'
end

p '### リッチメニュー操作スクリプト ###'
p '使い方は hlp を呼び出してください'