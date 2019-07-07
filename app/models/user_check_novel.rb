class UserCheckNovel < ApplicationRecord
  belongs_to :user
  belongs_to :novel

  class << self
    def link_user_to_novel(user_id, novel_id)
      record = where(user_id: user_id, novel_id: novel_id)
      if record.empty?
        create(user_id: user_id, novel_id: novel_id)
        registed
      else
        already_registered
      end
    end

    private

    def already_registered
      true
    end

    def registed
      false
    end
  end
end
