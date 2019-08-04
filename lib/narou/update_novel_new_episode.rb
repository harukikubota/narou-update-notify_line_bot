require_relative '../narou.rb'

module Narou::UpdateNovelNewEpisode extend self
  def batch
    UpdateNovelNewEpisode.new.run
  end

  class UpdateNovelNewEpisode
    include Narou

    def run
      # 更新がある小説一覧を取得
      updated_novels = fetch_has_next_episode_novels(Novel.order(ncode: :DESC))
      # 更新がある小説一覧のエピソード数を更新する
      updated_novels.map! { |novel| novel.update(last_episode_id: novel.last_episode_id.next); novel }
      # 更新した小説一覧のid
      updated_novel_ids = updated_novels.map(&:id)
      # 更新した小説を登録してるユーザ一覧を取得する
      notify_novel_datas = UserCheckNovel.where(novel_id: updated_novel_ids).order(:user_id)
      # 通知データを作成する
      ret = notify_novel_datas.map do |notify_novel_data|
        UserNotifyNovel.create(
          novel_id: notify_novel_data.novel_id,
          user_id: notify_novel_data.user_id,
          notify_novel_type: :update_post,
          notify_novel_episode_no: notify_novel_data.novel.last_episode_id
        )
      end

      ret.empty? ? no_updates : some_updates(ret)
    end

    private

    # @params Novels
    # @return 更新があるNovels
    def fetch_has_next_episode_novels(novels)
      datas = novels.each_slice(Constants::NAROU_API_QUERY_ATTRIBUTE_LIMIT_MAX)
      ret = datas.each_with_object([]) do |novels_data, arr|
        fetch_data = Narou.fetch_next_episodes(novels_data.map(&:ncode))
        arr << novels_data
          .each_with_index
          .reject { |novel, index| novel.last_episode_id == fetch_data[index].episode_count }
          .map(&:first)
      end

      ret.flatten
    end

    def no_updates
      Rails.logger.info('小説更新: ありませんでした。')
    end

    def some_updates(items)
      Rails.logger.info("小説更新: #{items.count}件の通知があります。")
    end
  end
end
