class RemovePresidentFromMembers < ActiveRecord::Migration
  def up
    remove_column :members, :president
      end

  def down
    add_column :members, :president, :boolean
  end
end
