class CreatePhrases < ActiveRecord::Migration
  def change
    create_table :phrases do |t|
      t.string :text
      t.string :category

      t.timestamps
    end
  end
end
