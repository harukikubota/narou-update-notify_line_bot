class User < ApplicationRecord
  has_many :user_check_novels
  has_many :novels, through: :user_check_novels
  has_many :user_check_writers
  has_many :writers, through: :user_check_writers

  class << self
    # novel.id を引数に、novel.id を登録かつ退会していない人一覧を取得する
    def find_effective_users_in_novel(novel_id)
      joins(:novels)
        .select('novels.*, users.*')
        .where(novels: { id: novel_id }, users: { enable: true })
    end

    # writer.id を引数に、writer.id を登録かつ退会していない人一覧を取  得する
    def find_effective_users_in_writer(writer_id)
      joins(:writers)
        .select('writers.*, users.*')
        .where(writers: { id: writer_id }, users: { enable:   true })
    end
  end

  def enable_to_user
    update(enable: true) unless enable?
  end

  def disable_to_user
    update(enable: false) if enable?
  end
end
