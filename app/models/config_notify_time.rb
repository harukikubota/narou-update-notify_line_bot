class ConfigNotifyTime < ApplicationRecord
  has_one :user_config

  # 通知可能時間をRangeオブジェクトにして返す
  def to_range
    time_range_start..time_range_end
  end
end
