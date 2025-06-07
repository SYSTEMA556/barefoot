# db/migrate/XXXX_create_bookmarks.rb

class CreateBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :bookmarks do |t|
      t.references :user,  null: false, foreign_key: true
      t.references :novel, null: false, foreign_key: true
      t.timestamps
    end
    # user_id と novel_id のペアが重複しないようユニークインデックスを追加
    add_index :bookmarks, [:user_id, :novel_id], unique: true
  end
end
