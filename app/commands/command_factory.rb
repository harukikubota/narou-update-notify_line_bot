require_relative './text_command.rb'
require_relative './postback_command.rb'
require_relative './follow_command.rb'
require_relative './none_command.rb'

# TODO paramに、使用するコマンド基底クラスを指定する
class CommandFactory
  class << self
    def get_command_class(type)
      # type から、呼び出す具象コマンドクラスを決める
      base_command_class = base_command(type)
      Command.build(command_identifier)
    end

    def base_command(type)
      snake_case = "#{type}_command"
    end
  end
end