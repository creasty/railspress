class CreateNotificationTopics < ActiveRecord::Migration
  def change
    create_table :notification_topics do |t|
      t.string :name
    end
  end
end
