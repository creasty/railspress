class AddIndexOnNameToNotificationTopics < ActiveRecord::Migration
  def change
    add_index :notification_topics, :name, unique: true
  end
end
