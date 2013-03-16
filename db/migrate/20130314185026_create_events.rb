class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.date :day
      t.time :starttime
      t.time :endtime
      t.string :location
      t.string :subtitle
      t.text :info
      t.integer :priority
      t.date :newsuntil

      t.timestamps
    end
  end
end
