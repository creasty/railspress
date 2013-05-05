class CreateMeta < ActiveRecord::Migration
  def change
    create_table :meta do |t|
      t.references :object, polymorphic: true
      t.string :key
      t.text :value

      t.timestamps
    end

    add_index :meta, :object_id
  end

  def self.down
    change_table :meta do |t|
      t.remove_references :object, polymorphic: true
    end
  end
end
