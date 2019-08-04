desc "作者の新規投稿をチェックし、新規投稿があればデータをDBに登録する"
task :narou_update_writer_new_post_novel => :environment do
  Narou::UpdateWriterNewNovel.batch
end