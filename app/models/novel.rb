class Novel < ApplicationRecord
  has_many :user_check_novels
  has_many :users, through: :user_check_novels
  has_one :novel
  belongs_to :writer

  include Narou

  class << self
    def build_by_ncode(ncode)
      novel = find_by_ncode(ncode)
      return novel if novel

      ret, title, last_episode_id, posted_at = Narou.fetch_episode(ncode)
      return nil unless ret

      writer = Writer.build_by_ncode(ncode)

      create(
        ncode: ncode,
        title: title,
        writer_id: writer.id,
        last_episode_id: last_episode_id,
        posted_at: posted_at
      )
    end
  end
end
