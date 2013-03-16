class AddMajorToMembers < ActiveRecord::Migration
  def change
    add_column :members, :major, :string

  end
end
