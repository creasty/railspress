class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.references :taxonomy
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
