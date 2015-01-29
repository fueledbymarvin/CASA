class ChangeColumnInMembers < ActiveRecord::Migration
  def up
    change_column :members, :fbid, :string
  end

  def down
    change_column :members, :fbid, :integer
  end
end
