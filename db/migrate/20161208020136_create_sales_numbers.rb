class CreateSalesNumbers < ActiveRecord::Migration
  def change
    create_table :sales_numbers do |t|
      t.string :name
      t.string :number

      t.timestamps null: false
    end
  end
end
