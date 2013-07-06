class CreateSettingOptions < ActiveRecord::Migration
  def change
    create_table :setting_options do |t|
      t.string :name
    end
    add_index :setting_options, :name, unique: true
  end
end
