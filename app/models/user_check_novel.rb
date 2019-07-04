class UserCheckNovel < ApplicationRecord
  belongs_to :user
  belongs_to :novel

  class << self
    def set_entity(user_id, novel_id)
      record = self.where(user_id: user_id, novel_id: novel_id)
      self.create(user_id: user_id, novel_id: novel_id) if record.empty?
    end
  end
end
