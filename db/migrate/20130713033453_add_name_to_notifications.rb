class AddNameToNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :notification_topic_id
    add_column :notifications, :name, :string
    drop_table :notification_topics
  end
end
