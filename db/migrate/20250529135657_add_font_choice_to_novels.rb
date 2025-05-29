class AddFontChoiceToNovels < ActiveRecord::Migration[7.1]
  def change
    add_column :novels, :font_choice, :string
  end
end
