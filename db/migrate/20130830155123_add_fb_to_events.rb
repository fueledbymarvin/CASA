class AddFbToEvents < ActiveRecord::Migration
  def change
    add_column :events, :fb, :boolean

  end
end
