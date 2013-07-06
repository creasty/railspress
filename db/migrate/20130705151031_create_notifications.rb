class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :notification_topic
      t.references :user
      t.text :params

      t.timestamps
    end
  end
end
