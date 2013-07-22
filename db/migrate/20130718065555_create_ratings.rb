class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :user, null: false
      t.string :ratable_type, null: false
      t.integer :ratable_id, null: false
      t.integer :positive, default: 0
      t.integer :negative, default: 0

      t.timestamps
    end
    add_index :ratings, :user_id
  end
end
