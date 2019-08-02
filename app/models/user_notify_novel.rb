class UserNotifyNovel < ApplicationRecord
  belongs_to :user
  belongs_to :novel

  enum notify_novel_type: { new_post: 0, update_post: 1 }

  NOTIFY_DATA_ATTRIBUTE_COMMON = %i[ncode title].freeze
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
      attribute = get_attribute_based_on_notify_type(novel_type)
      data = Struct.new(*attribute)
    end

    private

    def get_attribute_based_on_notify_type(novel_type)
      case novel_type
      when :new_post
        new_post_attribute
      when :update_post
        update_post_attribute
      end
    end

    def new_post_attribute
      NOTIFY_DATA_ATTRIBUTE_COMMON + NOTIFY_DATA_ATTRIBUTE_NEW_POST
    end

    def update_post_attribute
      NOTIFY_DATA_ATTRIBUTE_COMMON + NOTIFY_DATA_ATTRIBUTE_UPDATE_POST
    end
  end
end
