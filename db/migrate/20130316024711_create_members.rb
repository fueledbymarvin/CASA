class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name
      t.string :position
      t.string :college
      t.date :class
      t.string :email
      t.text :blurb
      t.boolean :president

      t.timestamps
    end
  end
end
