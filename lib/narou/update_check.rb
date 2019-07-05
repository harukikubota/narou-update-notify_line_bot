require_relative '../narou.rb'
require 'date'

module Narou::UpdateCheck extend self

  def batch
    # UTC 0での計算 JT 7 ~ 22
    can_notify_time_range = [*1..14, *22..23]
    now_hour = DateTime.now.hour
    can_notify_time_range.include?(now_hour) ? UpdateCheck.new.run : Rails.logger.info('実行可能時間外')
  end

  class UpdateCheck
    include Narou

    def run
      novels = Novel.all
      @something_notify_flag = false
      notify_users_data = novels.each_with_object([]) do |novel, arr|
        if is_exist_next_episode?(novel)
          novel.update!(
            last_episode_id: Narou.next_episode_id(novel.last_episode_id)
          )
          arr << find_update_novel_to_user(novel) && @something_notify_flag = true
        end
      end

      @something_notify_flag ? notify_update_novel_to_user(notify_users_data) : Rails.logger.info('更新はありませんでした。')
    end

    private

    def is_exist_next_episode?(novel)
      _, episode_id = Narou.fetch_episode(novel.ncode)
      episode_id > novel.last_episode_id
    end

    def find_update_novel_to_user(novel)
      notify_element = Struct.new(:user_line_id, :novel_url, :novel_title)
      novel_url = Narou.narou_url(novel)
      ucns = UserCheckNovel.where(novel_id: novel.id)
      ret = ucns.each_with_object([]) do |ucn, arr|
        arr << notify_element.new(ucn.user.line_id, novel_url, novel.title)
      end

      ret
    end

    def notify_update_novel_to_user(users_data)
      users_data.flatten!.group_by(&:user_line_id)
      .each do |user_id, items|
        res = client.send(user_id, build_notify_data(items))

      end
    end

    def build_notify_data(items)
      message_title = "#{items.count}件の更新がありました。"
      message_body = ""
      items.each.with_index(1) {|item, index| message_body += "\n\n#{index}. #{item.novel_title}\n#{item.novel_url}"}
      message_title + message_body
    end

    def client
      @client ||= LineAccessor.new
    end
  end
end