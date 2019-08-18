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
      writer_ids = new_writer_and_novel_ids.map(&:writer_id).uniq
      novel_notification_target_users = UserCheckWriter.where(writer_id: writer_ids).order(:user_id)
      novels_group_by_user =
        novel_notification_target_users
          .group_by(&:user_id)
          .each_pair.inject({}) { |hash, (user_id, ucws)|
            hash[user_id] =
              ucws.map { |ucw|
                new_writer_and_novel_ids
                  .select { |ids| ids.writer_id == ucw.writer_id }
                  .map(&:novel_id)
              }.flatten
            hash
          }

      # 通知データを作成する
      ret = novels_group_by_user.each_pair.map do |user_id, novel_ids|
        novel_ids.map { |novel_id| create_notify_data(user_id, novel_id) }
      end

      ret.empty? ? no_new_post : some_posts(ret.flatten)
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

            # 更新なし？
            if new_novel_count.zero?
              next
            # 投稿数が減っている？
            elsif new_novel_count < 0
              abnormal_process(writer, new_novel_count)
              next
            end

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

    def create_notify_data(user_id, novel_id)
      UserNotifyNovel.create(
        novel_id: novel_id,
        user_id: user_id,
        notify_novel_type: :new_post,
        notify_novel_episode_no: 1
      )
    end

    def abnormal_process(writer, reduce_count)
      writer.update(novel_count: writer.novel_count + reduce_count)
      proc_hash = SecureRandom.urlsafe_base64(8)
      title = '作者投稿数に減少発生'
      text = "作者名:#{writer.name}\n減少数 #{reduce_count}\n実行ハッシュ #{proc_hash}"
      message = Slack.message_completion_ob_abnormal_processing(title, text)
      Slack.notify(message)
      comp_abnormal_process(proc_hash, reduce_count)
    end

    def no_new_post
      Rails.logger.info('新規投稿: ありませんでした。')
    end

    def some_posts(items)
      Rails.logger.info("新規投稿: #{items.count}件の通知があります。")
    end

    def comp_abnormal_process(proc_hash, reduce_count)
      Rails.logger.info("新規投稿: 異常時処理を実行しました。減少数#{reduce_count}, #{proc_hash}")
    end
  end
end
