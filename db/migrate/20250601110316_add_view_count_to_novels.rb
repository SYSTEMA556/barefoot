class AddViewCountToNovels < ActiveRecord::Migration[7.1]
  def change
    add_column :novels, :view_count, :integer, default: 0, null: false
  end
end
