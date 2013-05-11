class AddMultipleToTaxonomies < ActiveRecord::Migration
  def change
    add_column :taxonomies, :multiple, :boolean, default: false
  end
end
