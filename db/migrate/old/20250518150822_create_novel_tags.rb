class CreateNovelTags < ActiveRecord::Migration[7.1]
  def change
    create_table :novel_tags do |t|
      t.references :novel, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
