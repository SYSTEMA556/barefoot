class AddCautionToNovels < ActiveRecord::Migration[7.1]
  def change
    add_column :novels, :caution, :boolean
    add_column :novels, :caution_reason, :text
  end
end
