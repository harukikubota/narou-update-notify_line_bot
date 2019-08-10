class UserNotifyNovel < ApplicationRecord
  belongs_to :user
  belongs_to :novel

  enum notify_novel_type: { new_post: 0, update_post: 1 }

  NOTIFY_DATA_ATTRIBUTE_COMMON = %i[id user_id ncode title].freeze
  NOTIFY_DATA_ATTRIBUTE_NEW_POST = %i[writer_name].freeze
  NOTIFY_DATA_ATTRIBUTE_UPDATE_POST = %i[episode_no].freeze

  # １ユーザに対する、一度に通知できるデータの上限
  NOTIFY_CAN_PER_USER_MAX = 50

  class << self

    # 通知するためのデータ一覧を取得する
    #
    # @param [novel_type] 新規投稿: :new_post, 更新投稿: :update_post
    #
    # @return Array<Struct> 通知データ一覧
    #
    # @example
    #   ## 共通
    #     data.id           ID            UserNotifyNovel.id
    #     data.user_id      ユーザID       User.id
    #     data.ncode        Nコード        n2267be
    #     data.title        小説のタイトル  Ｒｅ：ゼロから始める異世界生活
    #
    #   ## 新規投稿
    #     data.writer_name  作者名
    #
    #   ## 更新投稿
    #     data.episode_no   エピソードNo    478
    #
    def build_notify_data(novel_type)
      notify_datas = notify_data_within_can_notification_time(novel_type)
      case novel_type
      when :new_post
        build_data_for_new_post(notify_datas)
      when :update_post
        build_data_for_update_post(notify_datas)
      end
    end

    # 通知データを通知済みにする
    #
    # @params [notify_data] self.build_notify_dataで取得した配列
    #
    # @return [chenge_count] 処理件数
    def mark_as_notified_to(notify_data)
      ids = notify_data.map(&:id)
      where(id: ids)
        .update(
          notified: true,
          notified_at: DateTime.now
        )
    end

    private

    def build_data_for_new_post(notify_datas)
      template = Struct.new(*new_post_attribute)
      notify_datas.map do |data|
        template.new(
          data.id,
          data.user_id,
          data.novel.ncode,
          data.novel.title,
          data.novel.writer.name
        )
      end
    end

    def build_data_for_update_post(notify_datas)
      template = Struct.new(*update_post_attribute)
      notify_datas.map do |data|
        template.new(
          data.id,
          data.user_id,
          data.novel.ncode,
          data.novel.title,
          data.notify_novel_episode_no
        )
      end
    end

    def new_post_attribute
      NOTIFY_DATA_ATTRIBUTE_COMMON + NOTIFY_DATA_ATTRIBUTE_NEW_POST
    end

    def update_post_attribute
      NOTIFY_DATA_ATTRIBUTE_COMMON + NOTIFY_DATA_ATTRIBUTE_UPDATE_POST
    end

    # 通知時間内のユーザを対象とした、通知データを取得する
    def notify_data_within_can_notification_time(notify_type)
      can_notify_users_id.map { |user_id|
        where(
          user_id: user_id,
          notify_novel_type: notify_type,
          notified: false
        )
          .order(:created_at).limit(50)
      }.flatten
    end

    # 通知可能時間内のユーザID一覧
    def can_notify_users_id
      User.find_can_notify_users.map(&:id)
    end
  end
end
