class AddPasswordDigestToNovels < ActiveRecord::Migration[7.1]
  def change
    add_column :novels, :password_digest, :string
  end
end
