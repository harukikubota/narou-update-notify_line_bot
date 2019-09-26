class Novel < ApplicationRecord
  has_many :user_check_novels
  has_many :users, through: :user_check_novels
  has_one :novel
  belongs_to :writer

  include Narou

  class << self
    def build_by_ncode(ncode)
      novel = where(ncode: ncode, deleted: false).first
      return novel if novel

      ret, title, last_episode_id, posted_at = Narou.fetch_episode(ncode)
      return nil unless ret

      writer = Writer.build_by_ncode(ncode)

      create(
        ncode: ncode,
        title: title,
        writer_id: writer.id,
        last_episode_id: last_episode_id,
        posted_at: posted_at
      )
    end

    # 有効な小説一覧を、ncode降順で取得する
    #
    # @return [Array<Novel>]
    def all_effective_novels
      where(deleted: false).order(ncode: :DESC)
    end

    # 指定した NovelId の レコードを対象に、エピソード新規投稿として更新する
    #
    # @params [ncode] 更新がある小説のNcode
    #         [posted_at] <DateTime> 投稿日時
    #
    # @return [novel] 更新したレコード
    def update_new_post_novels(ncode, posted_at)
      novel = find_by_ncode(ncode)
      novel.update(
        last_episode_id: novel.last_episode_id.next,
        posted_at: posted_at
      )

      novel
    end
  end

  # なろうAPIサーバから削除されている場合に呼び出す.
  def delete
    update!(
      deleted: true,
      deleted_at: DateTime.now
    )

    self
  end
end
