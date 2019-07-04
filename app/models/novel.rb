class Novel < ApplicationRecord
  has_many :users, through: :user_check_novels
  has_many :user_check_novels
end
