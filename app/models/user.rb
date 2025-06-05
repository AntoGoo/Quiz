class User < ApplicationRecord
  validates :pseudo, presence: true, uniqueness: true
  has_many :participations, dependent: :destroy
end
