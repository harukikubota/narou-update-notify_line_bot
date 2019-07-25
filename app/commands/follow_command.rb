require_relative './base_command.rb'

class FollowCommand < BaseCommand
  def self.build(class_identifier)
    @command_folder_path = Constants::Command::FOLLOW_COMMAND_PATH
    super(class_identifier)
  end
end
