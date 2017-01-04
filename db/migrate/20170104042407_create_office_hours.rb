class CreateOfficeHours < ActiveRecord::Migration
  def change
    create_table :office_hours do |t|
      t.string :name
      t.string :number

      t.timestamps null: false
    end
  end
end
