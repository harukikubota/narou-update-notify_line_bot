class User < ApplicationRecord
  has_many :user_check_novels
  has_many :novels, through: :user_check_novels

  class << self
    # novel.id を引数に、novel.id を登録かる退会していない人一覧を取得する
    def find_effective_users_in_novel(novel_id)
      joins(:novels)
        .select('novels.*, users.*')
        .where(novels: { id: novel_id }, users: { enable: true })
    end
  end

  def enable_to_user
    update(enable: true) unless enable?
  end

  def disable_to_user
    update(enable: false) if enable?
  end
end
