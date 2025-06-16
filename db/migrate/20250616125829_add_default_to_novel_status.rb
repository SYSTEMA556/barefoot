class AddDefaultToNovelStatus < ActiveRecord::Migration[7.1]
  def change
    change_column_default :novels, :status, from: nil, to: 1   # 1 = :published
  end
end
