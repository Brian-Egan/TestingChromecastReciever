class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
        i = 1
        t.text :room_code
        t.boolean :active
        10.times do
            t.integer "player_#{i}_id"
            t.text "player_#{i}_name"
            t.integer "player_#{i}_score"
            t.text "player_#{i}_phrase"
            i += 1
        end
      t.timestamps
    end
  end
end


