require 'active_support/core_ext/class/subclasses'
require_relative './command/add_novel.rb'

# Commandsの基底クラス
class Command
  NO_OVERRIDE_ERROR = 'no override error'
  NO_COMMAND_ERROR = '該当のコマンドがありません'

  def self.build(command_name, *params)
    # サブクラスなければエラー
    raise "#{NO_COMMAND_ERROR} #{command_name}" if subclasses.include?(command_name)

    const_get(command_name).new(*params)
  end

  # Commandの実行
  def call
    raise NO_OVERRIDE_ERROR
  end

  # Commandの実行結果
  # @success = true
  def success?
    @success
  end

  def message
    @message
  end

  protected

  def user
    @user ||= User.find_by_line_id(@user_info.line_id)
  end

  private

  def initialize(user_info, reqeust_info)
    @user_info = user_info
    @request_info = reqeust_info
    @success = false
  end
end