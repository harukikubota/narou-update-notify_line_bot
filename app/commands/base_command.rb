require 'active_support/core_ext/class/subclasses'

# Commandsの基底クラス
class BaseCommand
  attr_reader :message

  include CommandCommon
  include ConfigModule
  include MessageBuilder

  def call
    raise Constants::NO_OVERRIDE_ERROR
  end

  # Commandの実行結果
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
end
