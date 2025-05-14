class AddAuthorNameToNovels < ActiveRecord::Migration[7.1]
  def change
    add_column :novels, :author_name, :string
  end
end
