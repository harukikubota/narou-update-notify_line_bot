require_relative './text_command.rb'

# TODO paramに、使用するコマンド基底クラスを指定する
class CommandFactory
  def self.get_command(command_identifier, *params)
    TextCommand.build(command_identifier, *params)
  end
end