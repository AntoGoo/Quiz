class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :pseudo
      t.integer :total_points

      t.timestamps
    end
  end
end
