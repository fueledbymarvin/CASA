class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.text :info
      t.string :fblink

      t.timestamps
    end
  end
end
