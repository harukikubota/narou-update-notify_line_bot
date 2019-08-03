desc "作者の新規投稿をチェックし、新規投稿があればデータをDBに登録する"
task :narou_update_check_and_notify_new_novel => :environment do
  Narou::UpdateCheckNewNovel.batch
end