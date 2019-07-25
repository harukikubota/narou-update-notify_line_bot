# コンフィグ関連のモジュール。
module ConfigModule
  extend ActiveSupport::Concern
  included do

    # 現在使用している区切り文字を取得する。
    def now_use_separator
      user.find_user_use_separate
    end
  end
end