class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :game_session

  validates :score, numericality: { greater_than_or_equal_to: 0 }, presence: true
end
