desc "更新のあった小説をユーザへ通知する"
task :notify_to_user_update_novels => :environment do
  Narou::NotifyUpdateNovel.batch
end
