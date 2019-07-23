require 'active_support/core_ext/class/subclasses'

# TODO バージョン 1.1.0 で使用するようにする
# Commandsの基底クラス
class BaseCommand
  attr_reader :message
  NO_OVERRIDE_ERROR = 'no override error'
  NO_COMMAND_ERROR = '該当のコマンドがありません'
  COMMANDS_PAHT = './app/commands/'

  include MessageBuilder

  def call
    raise NO_OVERRIDE_ERROR
  end

  # Commandの実行結果
  # @success = true
  def success?
    @success
  end

  def self.build(command_identifier)
    file_name = command_identifier.downcase
    require "#{COMMANDS_PAHT}#{@command_folder_path}#{file_name}"
    to_camel_case = ->(str) { str.split('_').map(&:capitalize).join }
    const_get(to_camel_case.call(command_identifier))
  end

  protected

  def initialize(request_info)
    @request_info = request_info
    @success = false
  end

  def user
    @user ||= User.find_by_line_id(@request_info.user_info.line_id)
  end

  def messenger
    LineMessenger.new
  end
end
