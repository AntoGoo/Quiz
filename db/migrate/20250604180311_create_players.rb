class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :pseudo
      t.integer :high_score

      t.timestamps
    end
  end
end
