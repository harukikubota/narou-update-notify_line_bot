require_relative '../narou.rb'

module Narou::UpdateNovelNewEpisode extend self
  def batch
    UpdateNovelNewEpisode.new.run
  end

  class UpdateNovelNewEpisode
    include Narou

    def run
      # 更新がある小説一覧
      fetch_data_updated_novels = fetch_has_next_episode_novels

      novel_update = ->(d) { Novel.update_new_post_novels(d.ncode, d.posted_at) }
      # 更新がある小説一覧に対し更新処理を行う
      updated_novels = fetch_data_updated_novels.map { |data| novel_update.(data) }
      # 更新した小説一覧のid
      updated_novels_id = updated_novels.map(&:id)
      # 更新した小説を登録してるユーザ一覧を取得する
      notify_novel_datas = UserCheckNovel.where(novel_id: updated_novels_id).order(:user_id)
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
    # @return [fetch_datas(Array<ncode<String>, episode_no<Integer>, posted_at<DateTime>)]
    #   [ncode] String
    #   [episode_no] Integer 最新話のエピソードID
    #   [posted_at] DateTime 投稿日時
    def fetch_has_next_episode_novels
      novels = Novel.order(ncode: :DESC)
      datas = novels.each_slice(Constants::NAROU_API_QUERY_ATTRIBUTE_LIMIT_MAX)
      ret = datas.each_with_object([]) do |novels_data, arr|
        fetch_datas = Narou.fetch_next_episodes(novels_data.map(&:ncode))
        arr << fetch_datas
          .each_with_index
          .reject { |fetch_data, index| novels[index].last_episode_id == fetch_data.episode_no }
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
