class UserNotifyNovel < ApplicationRecord
  enum notify_novel_type: { new: 0, update: 1 }
end
