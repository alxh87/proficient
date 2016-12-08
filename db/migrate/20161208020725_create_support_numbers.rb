class CreateSupportNumbers < ActiveRecord::Migration
  def change
    create_table :support_numbers do |t|
      t.string :name
      t.string :number

      t.timestamps null: false
    end
  end
end
