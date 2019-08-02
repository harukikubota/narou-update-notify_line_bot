class ConfigNotifyTime < ApplicationRecord
  has_one :user_config

  class << self
    # 現在時間で通知可能な通知時間設定テーブルの id 一覧を取得する。
    #
    # @return Array<Integer>
    def find_can_notify_time_range_ids
      now_h = DateTime.now.hour
      query = 'time_range_start <= ? and time_range_end > ?'.freeze
      where(query, now_h, now_h).map(&:id)
    end
  end

  # 通知可能時間をRangeオブジェクトにして返す
  def to_range
    time_range_start..time_range_end
  end
end
