class CreateMiscs < ActiveRecord::Migration
  def change
    create_table :miscs do |t|
      t.text :babble

      t.timestamps
    end
  end
end
