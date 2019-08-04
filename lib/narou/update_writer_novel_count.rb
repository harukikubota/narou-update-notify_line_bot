module Narou::UpdateWriterNovelCount extend self
  def batch
    Job.new.run
  end

  class Job
    def run
      UserCheckWriter.all.each do |ucw|
        writer = ucw.writer
        writer.update(novel_count: writer.novel_count - 1)
      end
    end
  end
end