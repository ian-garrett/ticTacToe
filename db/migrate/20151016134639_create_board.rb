class CreateBoard < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.text :grid
    end

    remove_column :games, :board
    add_column :games, :board_id, :integer
  end
end
