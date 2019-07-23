require_relative './base_command.rb'

class FollowCommand < BaseCommand
  def self.build(class_identifier)
    @command_folder_path = 'follow_command/'
    super(class_identifier)
  end
end
