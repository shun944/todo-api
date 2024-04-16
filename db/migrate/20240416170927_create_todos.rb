class CreateTodos < ActiveRecord::Migration[7.1]
  def change
    create_table :todos do |t|
      t.string :title
      t.string :description
      t.string :due_date
      t.boolean :completed
      t.string :category
      t.string :user_id

      t.timestamps
    end
  end
end
