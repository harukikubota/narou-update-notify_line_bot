class UserCheckWriter < ApplicationRecord
  belongs_to :user
  belongs_to :writer

  class << self
    def link_user_to_writer(user_id, writer_id)
      record = where(user_id: user_id, writer_id: writer_id)
      if record.empty?
        create(user_id: user_id, writer_id: writer_id)
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
