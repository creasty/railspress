class AddReadToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :read, :bool, default: false
  end
end
