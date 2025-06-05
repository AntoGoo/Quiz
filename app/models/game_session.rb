class GameSession < ApplicationRecord
  belongs_to :quiz
  has_many :participations, dependent: :destroy
end
