class CreateWorkerCalls < ActiveRecord::Migration
  def change
    create_table :worker_calls do |t|
      t.string :callsid
      t.string :workercallsid

      t.timestamps null: false
    end
  end
end
