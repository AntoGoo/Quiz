class CreateGameSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :game_sessions do |t|
      t.references :quiz, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
