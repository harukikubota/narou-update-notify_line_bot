require_relative './base_command.rb'

class PostbackCommand < BaseCommand
  def self.build(class_identifier)
    @command_folder_path = Constants::Command::POSTBACK_COMMAND_PATH
    super(class_identifier)
  end

  def initialize(request_info)
    super
    @params = @request_info.data.params
  end
end
