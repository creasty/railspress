class AddNameToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :name, :string
    add_index :notifications, :name
  end
end
