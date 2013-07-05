class AddReadToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :read, :bool, default: false
  end
end
