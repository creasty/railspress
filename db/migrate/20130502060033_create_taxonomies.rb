class CreateTaxonomies < ActiveRecord::Migration
  def change
    create_table :taxonomies do |t|
      t.references :term
      t.string :name

      t.timestamps
    end
    add_index :taxonomies, :term_id
  end
end
