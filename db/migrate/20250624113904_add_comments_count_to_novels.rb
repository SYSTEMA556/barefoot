class AddCommentsCountToNovels < ActiveRecord::Migration[7.1]
  def change
    add_column :novels, :comments_count, :integer, null: false, default: 0
  end
end
