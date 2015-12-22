class CreateGame < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :status
      t.text :board
      t.integer :player_1_id, null: false
      t.integer :player_2_id
      t.timestamps null: false
    end
  end
end
