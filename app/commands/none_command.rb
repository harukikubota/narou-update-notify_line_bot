require_relative './base_command.rb'

class NoneCommand < BaseCommand
  def self.build(class_identifier)
    @command_folder_path = Constants::Command::NONE_COMMAND_PATH
    super(class_identifier)
  end
end
