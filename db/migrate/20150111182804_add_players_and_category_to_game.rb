class AddPlayersAndCategoryToGame < ActiveRecord::Migration
  def change
    add_column :games, :category, :string, required: true
    add_column :games, :players, :integer, default: 1
  end
end
