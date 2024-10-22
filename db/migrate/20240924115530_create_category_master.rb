class CreateCategoryMaster < ActiveRecord::Migration[7.1]
  def change
    create_table :category_masters do |t|
      t.string :category_name

      t.timestamps
    end
  end
end
