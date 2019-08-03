require_relative '../narou.rb'

module Narou::UpdateWriterNewNovel extend self

  def batch
    UpdateWriterNewNovel.new.run
  end

  class UpdateWriterNewNovel
    include Narou

    def run
      # 新規投稿小説一覧を取得(内部でレコード作成する)
      new_writer_and_novel_ids = fetch_new_novels(Writer.order(:writer_id))
      binding.pry
      writer_ids = new_writer_and_novel_ids.map(&:writer_id).uniq
      novel_notification_target_users = UserCheckWriter(writer_id: writer_ids).order(:user_id)
      # 通知データを作成する
      # TODO ここから
      ret = novel_notification_target_users.map do ||
        UserNotifyNovel.create(
          novel_id: notify_novel_data.novel_id,
          user_id: notify_novel_data.user_id,
          notify_novel_type: :new_post,
          notify_novel_episode_no: 1
        )
      end

      ret.empty? ? no_new_post : some_posts(ret)
    end

    private

    # @params Writers
    # @return Array<[Writer.id, Novel.id]> 新規投稿された Writer.id, Novel.id の配列
    def fetch_new_novels(writers)
      fetch_datas = Narou.fetch_writers_episodes_order_new_post(writers)
      ret =
        fetch_datas.each_with_object([]) do |writer_data, ar|
          writer_data.each_pair do |writer_id, data|
            writer = Writer.find_by_writer_id(writer_id)
            new_novel_count = data[:count] - writer.novel_count
            next if new_novel_count.zero?

            new_novel_ncodes =
              data[:ncodes].to_a.take(new_novel_count).map { |h| h[:ncode] }
            ar << new_novel_ncodes
                    .map { |ncode| Novel.build_by_ncode(ncode) }
                    .map(&:id)
                    .map { |id| Struct.new(:writer_id, :novel_id).new(writer.id, id) }
            writer.update(novel_count: data[:count])
          end
        end
      ret.flatten
    end

    def no_new_post
      Rails.logger.info('新規投稿: ありませんでした。')
    end

    def some_posts(items)
      Rails.logger.info("新規投稿: #{items.count}件の通知があります。")
    end
  end
end
