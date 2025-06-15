class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :email
      t.string :password_digest
      t.string :email_token
      t.boolean :email_confirmed

      t.timestamps
    end
  end
end
