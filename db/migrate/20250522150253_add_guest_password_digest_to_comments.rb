class AddGuestPasswordDigestToComments < ActiveRecord::Migration[7.1]
  def change
    # すでにカラムがあれば追加をスキップする
    unless column_exists?(:comments, :guest_password_digest)
      add_column :comments, :guest_password_digest, :string
    end
  end
end
