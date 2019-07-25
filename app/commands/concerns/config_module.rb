# コンフィグ関連のモジュール。
module ConfigModule
  extend ActiveSupport::Concern
  included do

    # 現在使用している区切り文字を取得する。
    def now_use_separator
      user.find_user_use_separate
    end

    # 現在設定している通知時間を取得する。
    def now_notify_range_time
      user.find_user_can_notify_time
    end

    # Rangeオブジェクトを「X時〜X時」に変換する
    def string_range_time_to(range)
      start_hour = range.first
      end_hour = range.last
      "#{start_hour}時〜#{end_hour}時"
    end
  end
end