class Writer < ApplicationRecord
  has_many :user_check_writers
  has_many :users, through: :user_check_writers

  class << self
    def build_by_writer_id(writer_id)
      writer = find_by_writer_id(writer_id)
      return writer if writer

      count, result = Narou.fetch_writer_episodes_order_new_post(writer_id)
      return nil unless result

      _t, _n, name = result[0].values

      create(
        writer_id: writer_id,
        name: name,
        novel_count: count
      )
    end
  end
end
