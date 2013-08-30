class AddFbidToEvents < ActiveRecord::Migration
  def change
    add_column :events, :fbid, :string

  end
end
