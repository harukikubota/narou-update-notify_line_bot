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

    def unlink_user_to_writer(user_id, writer_id)
      if record = find_by_userid_and_writerid(user_id, writer_id)
        record.destroy
        return destroyed
      else
        return already_destroyed
      end
    end

    def find_by_userid_and_writerid(user_id, writer)
      where(user_id: user_id, writer: writer).first || nil
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
