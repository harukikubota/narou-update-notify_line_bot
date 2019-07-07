module Narou::UpdateNovelEpisodeId extend self
  def batch
    Job.new.run
  end

  class Job
    def run
      Novel.limit(5).each do |novel|
        novel.update(last_episode_id: novel.last_episode_id - 1)
      end
    end
  end
end