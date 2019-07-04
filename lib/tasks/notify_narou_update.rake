desc "なろうの更新がないかチェックし、通知する"
task :narou_update_check_and_notify_update_episode => :environment do
  Narou::UpdateCheck.batch
end