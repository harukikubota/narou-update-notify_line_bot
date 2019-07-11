desc "登録されている作者の投稿数をデクリメントする"
task :update_writer_novel_count_minus_one => :environment do
  Narou::UpdateWriterNovelCount.batch
end
