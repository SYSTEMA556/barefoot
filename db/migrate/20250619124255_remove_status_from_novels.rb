class RemoveStatusFromNovels < ActiveRecord::Migration[7.1]
  def change
    remove_column :novels, :status, :integer
  end
end
