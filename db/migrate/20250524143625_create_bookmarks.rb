# db/migrate/20250524143625_create_bookmarks.rb
class CreateBookmarks < ActiveRecord::Migration[7.1]
  def change
    create_table :bookmarks do |t|
      t.references :user,  null: false, foreign_key: true
      t.references :novel, null: false, foreign_key: true

      t.timestamps
    end

    # テーブル作成後にユニークインデックスを追加
    add_index :bookmarks, [:user_id, :novel_id], unique: true
  end
end
