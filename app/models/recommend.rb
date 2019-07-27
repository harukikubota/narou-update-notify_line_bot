class Recommend < ApplicationRecord
  belongs_to :novel
  belongs_to :writer

  class << self
    def build_recommend_by_ncodes(ncodes)
      novels = ncodes.map { |ncode| Novel.build_by_ncode(ncode) }
      return raise '存在しない小説が指定されています！！' if novels.include?(nil)

      novels.each.with_index(1) do |novel, index|
        writer = Writer.build_by_ncode(novel.ncode)
        create(novel_id: novel.id, writer_id: writer.id, rank: index)
      end
    end

    # おすすめを表示順で取得する
    def recommends_order_rank
      order(:rank).limit(10)
        .joins(:novel).eager_load(:novel)
        .joins(:writer).eager_load(:writer)
    end
  end
end
