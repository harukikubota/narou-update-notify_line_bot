class User < ApplicationRecord
  has_many :novels, through: :user_check_novels
  has_many :user_check_novels
end
