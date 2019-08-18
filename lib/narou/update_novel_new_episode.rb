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

      ret.flatten!
      # エピソードが減っていれば異常時処理
      decreasing_novel_episode(ret)

      ret
    end

    def decreasing_novel_episode(fetch_datas)
      fetch_datas.each do |fetch_data|
        novel = Novel.find_by_ncode(fetch_data.ncode)
        reduce_count = fetch_data.episode_no - novel.last_episode_id
        # 減少している場合
        if reduce_count < 0
          abnormal_process(novel, reduce_count.abs)
        end
      end
    end

    def abnormal_process(novel, reduce_count)
      novel.update(last_episode_id: novel.last_episode_id - reduce_count)
      proc_hash = SecureRandom.urlsafe_base64(8)
      title = '小説のエピソードIDに減少発生'
      text = "小説名:#{novel.title}\n減少数 #{reduce_count}\n実行ハッシュ #{proc_hash}"
      message = Slack.message_completion_ob_abnormal_processing(title, text)
      Slack.notify(message)
      comp_abnormal_process(proc_hash, reduce_count)
    end

    def no_updates
      Rails.logger.info('小説更新: ありませんでした。')
    end

    def some_updates(items)
      Rails.logger.info("小説更新: #{items.count}件の通知があります。")
    end

    def comp_abnormal_process(proc_hash, reduce_count)
      Rails.logger.info("小説更新: 異常時処理を実行しました。減少数#{reduce_count}, #{proc_hash}")
    end
  end
end
