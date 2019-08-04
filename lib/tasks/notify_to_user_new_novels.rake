desc "新規投稿小説をユーザへ通知する"
task :notify_to_user_new_novels => :environment do
  Narou::NotifyNewNovel.batch
end
