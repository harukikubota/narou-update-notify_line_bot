require 'active_support/core_ext/class/subclasses'

# TODO バージョン 1.1.0 で使用するようにする
# Commandsの基底クラス
class BaseCommand
  NO_OVERRIDE_ERROR = 'no override error'
  NO_COMMAND_ERROR = '該当のコマンドがありません'

  def call
    raise NO_OVERRIDE_ERROR
  end

  # Commandの実行結果
  # @success = true
  def success?
    @success
  end

  protected

  # 指定したコマンドクラスを取得する
  #
  # params
  #   [command_class_name] ADD_NOVEL 大文字であり、単語間は _ で区切られている
  #   [command_folder_path]
  #
  def command(command_class_name, command_folder_path)
    file_name = snake_case_to(command_class_name)
    require "#{command_folder_path}#{file_name}"
  end

  private

  def snake_case_to(str)
    str.downcase
  end
end
