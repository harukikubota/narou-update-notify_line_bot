require_relative './text_command.rb'
require_relative './postback_command.rb'
require_relative './follow_command.rb'
require_relative './none_command.rb'

class CommandFactory
  class << self
    def get_command(request_info)
      # type から、呼び出す具象コマンドクラスを決める
      command = const_get(base_command_name(request_info.type)).build(request_info.identifier)
      command.new(request_info)
    end

    private

    def base_command_name(type)
      "#{type}_command".camelize
    end
  end
end
