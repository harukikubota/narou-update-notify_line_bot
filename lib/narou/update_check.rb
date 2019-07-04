require_relative '../narou.rb'

module Narou::UpdateCheck extend self

  def batch
    UpdateCheck.new.run
  end

  class UpdateCheck
    include Narou

    def run
      novels = Novel.all
      @something_notify_flag = false
      notify_users = novels.each.with_object([]) do |novel, users|
        if is_exist_next_episode?(novel)
          novel.update!(
            last_episode_id: Narou.next_episode_id(novel.last_episode_id)
          )
          users << notify_update_novel_to_user(novel) && @something_notify_flag = true
        end
      end

      notify

      Rails.logger.info('更新はありませんでした。') if @something_notify_flag
    end

    private

    def is_exist_next_episode?(novel)
      _, episode_id = Narou.fetch_episode(novel.ncode)
      episode_id == Narou.next_episode_id(novel.last_episode_id)
    end

    def find_update_novel_to_user(novel)
      users = UserCheckNovel.find_by_novel(novel)
      users.product(novel.ncode)
    end

    def notify_data(novel)
      "'{\"attachments\":[{\"color\":\"#003399\",\"pretext\":\"更新がありました。\",\"title\":\"#{novel.title}\",\"text\":\"https://ncode.syosetu.com/#{novel.ncode}/#{novel.last_episode_id}/\"}]}'"
    end
  end
end