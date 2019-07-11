desc "なろうの更新がないかチェックし、通知する"
task :narou_update_check_and_notify_new_novel => :environment do
  Narou::UpdateCheckNewNovel.batch
end