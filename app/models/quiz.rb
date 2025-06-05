class Quiz < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :game_sessions, dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true
  validates :title, presence: true
  validates :description, presence: true
  validates :num_questions, numericality: { only_integer: true, greater_than: 0 }
end
