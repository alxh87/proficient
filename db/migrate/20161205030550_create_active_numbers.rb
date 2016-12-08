class CreateActiveNumbers < ActiveRecord::Migration
  def change
    create_table :active_numbers do |t|
      t.string :area
      t.string :name
      t.string :number

      t.timestamps null: false
    end
  end
end
