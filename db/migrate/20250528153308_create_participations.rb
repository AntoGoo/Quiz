class CreateParticipations < ActiveRecord::Migration[7.1]
  def change
    create_table :participations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game_session, null: false, foreign_key: true
      t.integer :score

      t.timestamps
    end
  end
end
