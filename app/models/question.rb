class Question < ApplicationRecord
  belongs_to :quiz
  has_many :options, dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true

  #validate :must_have_eight_options
  #validate :must_have_two_correct_options

  #private

  #def must_have_eight_options
    #errors.add(:options, "Une question doit contenir exactement 8 réponses.") if options.size != 8
  #end

  #def must_have_two_correct_options
    #errors.add(:options, "Il doit y avoir exactement 2 réponses correctes.") unless options.select(&:correct).size == 2
  #end
end