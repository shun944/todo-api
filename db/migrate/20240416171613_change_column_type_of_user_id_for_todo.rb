class ChangeColumnTypeOfUserIdForTodo < ActiveRecord::Migration[7.1]
  def change
    change_column :todos, :user_id, :bigint
    add_foreign_key :todos, :users
  end
end
