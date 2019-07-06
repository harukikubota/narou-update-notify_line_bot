require_relative './command.rb'

class CommandFactory
  def self.get_command(command_identifier, *params)
    Command.build(get_command_name(command_identifier), *params)
  end

  private

  def self.get_command_name(identifier)

    commands_map[identifier.to_sym]
  end

  def self.commands_map
    {
      add_novel: 'AddNovel',
      novel_list: 'NovelList'
    }
  end
end