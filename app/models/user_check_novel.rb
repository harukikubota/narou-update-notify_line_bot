class UserCheckNovel < ApplicationRecord
  belongs_to :user
  belongs_to :novel

  class << self
    def set_entity(user_id, novel_id)
      record = where(user_id: user_id, novel_id: novel_id)
      record = create(user_id: @user.id, novel_id: novel.id) unless record
    end
  end
end
