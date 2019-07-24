class UserCheckNovel < ApplicationRecord
  belongs_to :user
  belongs_to :novel

  class << self

    # ユーザと小説を紐づける
    #
    # @params [user_id] User.id
    #         [novel_id] Novel.id
    #
    # @return [registered?] レコードを追加 : レコードは追加済
    #
    def link_user_to_novel(user_id, novel_id)
      if find_by_userid_and_novelid(user_id, novel_id)
        already_registered
      else
        create(user_id: user_id, novel_id: novel_id)
        registed
      end
    end

    def unlink_user_to_novel(user_id, novel_id)
      if record = find_by_userid_and_novelid(user_id, novel_id)
        record.destroy
        return destroyed
      else
        return already_destroyed
      end
    end

    def find_by_userid_and_novelid(usr_id, nvl_id)
      where(user_id: usr_id, novel_id: nvl_id).first || nil
    end

    private

    def already_registered
      true
    end

    def destroyed
      true
    end

    def registed
      false
    end

    def already_destroyed
      false
    end
  end
end
