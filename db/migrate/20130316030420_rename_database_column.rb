class RenameDatabaseColumn < ActiveRecord::Migration
  def up
  	rename_column :members, :class, :gradyear
  end

  def down
  	rename_column :members, :gradyear, :class
  end
end
