class CreateMeta < ActiveRecord::Migration
  def change
    create_table :metas do |t|
      t.references :object, polymorphic: true
      t.string :key
      t.text :value

      t.timestamps
    end

    add_index :metas, :object_id
    add_index :metas, :object_type
  end

  def self.down
    change_table :metas do |t|
      t.remove_references :object, polymorphic: true
    end
  end
end
