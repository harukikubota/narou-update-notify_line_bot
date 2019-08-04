desc "なろうの更新がないかチェックし、更新があればデータをDBに登録する"
task :narou_update_novel_new_episode => :environment do
  Narou::UpdateNovelNewEpisode.batch
end