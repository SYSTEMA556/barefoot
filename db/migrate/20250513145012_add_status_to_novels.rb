class AddStatusToNovels < ActiveRecord::Migration[7.1]
  def change
    add_column :novels, :status, :integer
  end
end
