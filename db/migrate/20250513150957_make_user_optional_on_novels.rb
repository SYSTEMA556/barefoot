class MakeUserOptionalOnNovels < ActiveRecord::Migration[7.1]
  def change
    # user_id カラムを null: true に変更
    change_column_null :novels, :user_id, true
  end
end
