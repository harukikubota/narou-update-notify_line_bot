require 'active_support/core_ext/class/subclasses'

# Commandsの基底クラス
class BaseCommand
  include CommandCommon
  include ConfigModule
  include MessageBuilder
  include NarouModule

  # 固有処理
  def call
    raise Constants::NO_OVERRIDE_ERROR
  end

  # 処理後にAPI通信をまとめて行う
  def after_call
    mes_ret = @message && send_message(@message)
    menu_ret = @rich_menu_id && change_rich_menu(@rich_menu_id)
  end

  # 各Command.call の実行結果
  # @success = true
  def success?
    @success
  end

  def self.build(command_identifier)
    file_name = command_identifier.downcase
    to_camel_case = ->(str) { str.split('_').map(&:capitalize).join }

    begin
      require "#{Constants::Command::COMMANDS_PAHT}#{@command_folder_path}#{file_name}"
      const_get(to_camel_case.call(command_identifier))
    rescue => exception
      Rails.logger.fetal(Constants::Command::NO_COMMAND_ERROR)
    end
  end

  protected

  def initialize(request_info)
    @request_info = request_info
    @success = false
  end

  private

  # ユーザへリプライを送信する
  #
  # @params [message] リプライメッセージ
  def reply_message(message)
    client.reply_message(@request_info.user_info.reply_token, message)
  end

  # ユーザのメニューを切り替える
  #
  # @params [rich_menu_id]
  def change_rich_menu(rich_menu_id)
    client.link_user_rich_menu(user.line_id, rich_menu_id)
  end
end
