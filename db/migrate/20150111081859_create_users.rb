class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :auth_token
      t.string :email_address
      t.string :sms

      t.timestamps
    end
  end
end
