class AddGuestPasswordToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :guest_password_digest, :string
  end
end
