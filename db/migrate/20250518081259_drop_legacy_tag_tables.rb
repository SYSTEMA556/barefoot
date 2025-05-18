class DropLegacyTagTables < ActiveRecord::Migration[7.1]
  def up
    drop_table :novel_tags, if_exists: true                           # 手動中間テーブルを削除 :contentReference[oaicite:1]{index=1}
    drop_table :tags,       if_exists: true                           # 手動タグテーブルを削除 :contentReference[oaicite:2]{index=2}
  end

  def down
    # 必要なら復元用 create_table を記述
    create_table :tags, force: true do |t|
      t.string :name, null: false
      t.timestamps
    end
    create_table :novel_tags, force: true do |t|
      t.references :novel, null: false, foreign_key: true
      t.references :tag,   null: false, foreign_key: true
      t.timestamps
    end
  end
end
