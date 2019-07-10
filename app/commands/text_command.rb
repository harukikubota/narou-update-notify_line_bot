require_relative './base_command.rb'

class TextCommand < BaseCommand

  def self.build(command_identifier, *params)
    files = Rails.root.glob('app/commands/command/*.rb')
      .map(&:to_s)
      .map { |file| file.split('/') }
      .map { |file| file.drop_while { |dir| !dir.include?('app') } }
      .map { |file| file.join('/').sub(/.rb/, '') }
      .map { |file| './' + file }

    files.each { |file| require file }
    command_name = get_command_name(command_identifier)

    const_get(command_name).new(*params)
  end

  def message
    @message
  end

  def message_type
    @message_type ||= type
  end

  protected

  def user
    @user ||= User.find_by_line_id(@user_info.line_id)
  end

  # メッセージタイプが違う場合はオーバーライドする
  def type
    Constants::LineMessage::MessageType::TYPE_PLANE
  end

  private

  def initialize(user_info, reqeust_info)
    @user_info = user_info
    @request_info = reqeust_info
    @success = false
  end

  class << self

    def get_command_name(identifier)

      commands_map[identifier.to_sym]
    end

    def commands_map
      {
        follow: 'Follow',
        unfollow: 'UnFollow',
        novel_add: 'NovelAdd',
        novel_list: 'NovelList',
        novel_delete: 'NovelDelete',
        help: 'Help',
        info: 'Info',
        line: 'LineResponse',
        none: 'None',
        debug: 'Debug',
      }
    end
  end
end