class User < ApplicationRecord
  has_many :user_check_novels
  has_many :novels, through: :user_check_novels
  has_many :user_check_writers
  has_many :writers, through: :user_check_writers
  has_one :user_config

  class << self
    def new_user(line_id)
      default_config = UserConfig.default_record
      user = create(line_id: line_id)
      default_config.user_id = user.id
      default_config.save
      user.update(user_config_id: default_config.id)
    end

    # novel.id を引数に、novel.id を登録かつ退会していない人一覧を取得する
    def find_effective_users_in_novel(novel_id)
      joins(:novels)
        .select('novels.*, users.*')
        .where(novels: { id: novel_id }, users: { enable: true })
    end

    # writer.id を引数に、writer.id を登録かつ退会していない人一覧を取得する
    def find_effective_users_in_writer(writer_id)
      joins(:writers)
        .select('writers.*, users.*')
        .where(writers: { id: writer_id }, users: { enable: true })
    end

    # 通知可能時間内のユーザ一覧を取得する。
    def find_can_notify_users
      cnt_ids = ConfigNotifyTime.find_can_notify_time_range_ids
      joins(:user_config).eager_load(:user_config)
        .where(user_configs: { config_notify_time_id: cnt_ids })
    end
  end

  # ブロック解除時
  def enable_to_user
    update(enable: true) unless enable?
  end

  # ブロック時
  def disable_to_user
    update(enable: false) if enable?
  end

  # 使用している区切り文字を取得する
  #
  # return [separate] "-"
  #
  def find_user_use_separate
    ConfigSeparate.where(
      id: UserConfig.where(user_id: id).select(:config_separate_id)
    ).first.use_str
  end

  # 通知可能な時間を取得する
  #
  # return [can_notify_time_range] <Range 7..23>
  #
  def find_user_can_notify_time
    ret = ConfigNotifyTime.where(
      id: UserConfig.where(user_id: id).select(:config_notify_time_id)
    ).first
    (ret.time_range_start)..(ret.time_range_end)
  end

  # 指定した作者IDで、ユーザが登録している小説一覧を取得する
  # @params [writer_id] 作者ID
  #
  # @return [novels] 小説一覧
  def regist_novel_list_by_writer_id(writer_id)
    Novel
      .joins(:user_check_novels)
      .joins(:writer)
      .where(
        novels: { writer_id: writer_id }, user_check_novels: { user_id: id }
      )
  end
end
