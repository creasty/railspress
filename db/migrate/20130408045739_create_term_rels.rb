class CreateTermRels < ActiveRecord::Migration
  def change
    create_table :term_rels do |t|
      t.references :object, polymorphic: true
      t.references :term

      t.timestamps
    end
    add_index :term_rels, :term_id
  end

  def self.down
    change_table :term_rels do |t|
      t.remove_references :object, polymorphic: true
    end
  end
end
