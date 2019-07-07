class Novel < ApplicationRecord
  has_many :user_check_novels
  has_many :users, through: :user_check_novels

  include Narou
  class << self
    def build_by_ncode(ncode)
      novel = find_by_ncode(ncode)
      return novel if novel

      ret, title, last_episode_id = Narou.fetch_episode(ncode)
      return nil unless ret

      create(
        ncode: ncode,
        title: title,
        last_episode_id: last_episode_id
      )
    end
  end
end
