desc "登録されている小説の最新エピソードIDをデクリメントする"
task :update_novel_last_episode_id_minus_one => :environment do
  Narou::UpdateNovelEpisodeId.batch
end
