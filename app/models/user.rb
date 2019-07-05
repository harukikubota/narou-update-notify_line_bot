class User < ApplicationRecord
  has_many :user_check_novels
  has_many :novels, through: :user_check_novels

  class << self
    def find_or_create(user_id)
      user = find_by_line_id(user_id)
      if user
        return user
      else
        create(
          line_id: user_id
        )
      end
    end

    def enable_to_user(user)
      user.update(enable: true) unless user.enable?
    end

    def disable_to_user(user)
      user.update(enable: false)
    end
  end
end
