module Narou::UpdateNovelEpisodeId extend self
  def batch
    Job.new.run
  end

  class Job
    def run
      Novel.all.each do |novel|
        novel.update(last_episode_id: novel.last_episode_id - 1)
      end
    end
  end
end