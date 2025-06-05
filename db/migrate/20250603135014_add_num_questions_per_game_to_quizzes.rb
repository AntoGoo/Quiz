class AddNumQuestionsPerGameToQuizzes < ActiveRecord::Migration[7.1]
  def change
    add_column :quizzes, :num_questions_per_game, :integer
  end
end
