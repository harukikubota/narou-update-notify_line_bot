class UserNotifyNovel < ApplicationRecord
  belongs_to :user
  belongs_to :novel

  enum notify_novel_type: { new_post: 0, update_post: 1 }

  NOTIFY_DATA_ATTRIBUTE_COMMON = %i[id user_id ncode title].freeze
  NOTIFY_DATA_ATTRIBUTE_NEW_POST = %i[writer_name].freeze
  NOTIFY_DATA_ATTRIBUTE_UPDATE_POST = %i[episode_no].freeze

  class << self

    # 通知するためのデータ一覧を整形する
    #
    # @param [novel_type] 新規投稿: :new_post, 更新投稿: :update_post
    #
    # @return Array<Struct> 通知データ一覧
    #
    # @example
    #   ## 共通
    #     data.id           ID            UserNotifyNovel.id
    #     data.user_id      ユーザID       User.id
    #     data.ncode        Nコード        /n\d{4}\w{1,3}/
    #     data.title        小説のタイトル  Ｒｅ：ゼロから始める異世界生活
    #
    #   ## 新規投稿
    #     data.writer_name  作者名
    #
    #   ## 更新投稿
    #     data.episode_no   エピソードNo    478
    #
    def build_notify_data(novel_type)
      case novel_type
      when :new_post
        build_data_for_new_post
      when :update_post
        build_data_for_update_post
      end
    end

    private

    def build_data_for_new_post
      template = Struct.new(*new_post_attribute)
      notify_datas = notify_data_within_can_notification_time
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

    def build_data_for_update_post
      template = Struct.new(*update_post_attribute)
      notify_datas = notify_data_within_can_notification_time
      notify_datas.map do |data|
        template.new(
          data.id,
          data.user_id,
          data.novel.ncode,
          data.novel.title,
          data.novel.last_episode_id
        )
      end
    end

    def new_post_attribute
      NOTIFY_DATA_ATTRIBUTE_COMMON + NOTIFY_DATA_ATTRIBUTE_NEW_POST
    end

    def update_post_attribute
      NOTIFY_DATA_ATTRIBUTE_COMMON + NOTIFY_DATA_ATTRIBUTE_UPDATE_POST
    end

    def can_notify_users_id
      User.find_can_notify_users.map(&:id)
    end

    def notify_data_within_can_notification_time
      where(user_id: can_notify_users_id).order(:user_id, :created_at)
    end
  end
end
