require_relative './command.rb'

class CommandFactory
  def self.get_command(command_identifier, *params)
    Command.build(command_identifier, *params)
  end
end