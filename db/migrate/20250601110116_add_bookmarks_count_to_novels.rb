class AddBookmarksCountToNovels < ActiveRecord::Migration[7.1]
  def change
    add_column :novels, :bookmarks_count, :integer, default: 0, null: false
  end
end
