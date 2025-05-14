class AllowNullUserIdOnNovels < ActiveRecord::Migration[7.1]
  def change
    # user_id の NOT NULL 制約を外す
    change_column_null :novels, :user_id, true
  end
end
