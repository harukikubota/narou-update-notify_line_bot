class UserCheckNovel < ApplicationRecord
  be_longs_to :user
  be_longs_to :novel
end
