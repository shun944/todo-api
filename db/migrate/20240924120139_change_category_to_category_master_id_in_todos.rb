class ChangeCategoryToCategoryMasterIdInTodos < ActiveRecord::Migration[7.1]
  def change
    remove_column :todos, :category
    add_column :todos, :category_master_id, :integer
    add_foreign_key :todos, :category_masters, column: :category_master_id
  end
end
