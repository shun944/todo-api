class AddStartDateToTodos < ActiveRecord::Migration[7.1]
  def change
    add_column :todos, :start_date, :string
  end
end
