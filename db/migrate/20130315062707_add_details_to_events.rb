class AddDetailsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :addend, :boolean

    add_column :events, :hassub, :boolean

    add_column :events, :newsletter, :boolean

  end
end
