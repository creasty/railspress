class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.references :setting_option
      t.references :user
      t.string :params
    end
    add_index :settings, :setting_option_id
    add_index :settings, :user_id
  end
end
