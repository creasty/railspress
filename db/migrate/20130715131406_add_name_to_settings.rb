class AddNameToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :name, :string
    add_index :settings, :name
  end
end
