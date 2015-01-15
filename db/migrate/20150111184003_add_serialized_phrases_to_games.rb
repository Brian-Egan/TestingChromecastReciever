class AddSerializedPhrasesToGames < ActiveRecord::Migration
  def change
    add_column :games, :phrases, :string
  end
end
