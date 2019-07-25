require 'line/bot'
require 'json'
require_relative '../line_request/line_client.rb'

# ---------------------------------- #
# 【使い方】
# $ source $project_dir/.richmenurc
# pry(main)> Ctrl + V
# ---------------------------------- #

# APIに設定されているリッチメニューの一覧を表示する。
def list
  res = client.get_rich_menus
  ret = JSON.parse(res.body)
  menus = ret['richmenus'].map { |item| [item['name'], item['richMenuId']] }
  menus.map.with_index(1) {|(name, id), index| "#{index}. #{name}: #{id}" }
end

# DBにはレコードなし、LINEAPIサーバには登録済の時に使用する。
def set_db_by_fetch_line_api
  lists = list.each_with_object(' ').map(&:split).each_with_object(2).map(&:last)
  lists.each { |l| create(*l) }
end

# DB、LINEAPIサーバにリッチメニューが登録されていない時に使用する。
def set_db_and_line_api
  # 指定したディレクトリからファイル一覧を取得する。ファイル名のみ。
  find_files = ->(path) { Dir.glob(path + '*').each_with_object('/').map(&:split).map(&:last).map { |file_name| File.basename(file_name) } }
  base_name_files = find_files.call(data_path).sort
  image_files_by_name = find_files.call(image_path).sort

  # JSONファイル名、IMAGEファイル名を渡し、DBとAPIに登録する。
  base_name_files.zip(image_files_by_name).each do |json, image|
    create_rich_menu(json, image)
  end

  # デフォルトのリッチメニューを設定する。
  default_rich_menu = RichMenu.find_by_name('top-menu')
  client.set_default_rich_menu(default_rich_menu.rich_menu_id)
end

def api_rich_menu_delete_all
  ids = list.each_with_object(' ').map(&:split).map(&:last)
  ids.each { |id| client.delete_rich_menu(id) }
end

def create_rich_menu(rich_menu_obj_name, image_name)
  json_obj = to_json_obj_rich_menu(rich_menu_obj_name)
  img_obj = to_image_obj_rich_menu(image_name)
  name = File.basename(rich_menu_obj_name, '.*')

  res = client.create_rich_menu(json_obj)
  rich_menu_id = res.body.scan(/(richmenu-\w+)/)[0][0]
  create(rich_menu_id, name)
  client.create_rich_menu_image(rich_menu_id, img_obj)
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

def create(rich_menu_id, name)
  if menu = RichMenu.find_by_name(name)
    menu.update(rich_menu_id: rich_menu_id)
  else
    RichMenu.create(
      rich_menu_id: rich_menu_id,
      name: name
    )
  end
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