class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :status, defualt: 0
      t.string :slug
      t.string :title
      t.string :excerpt
      t.text :content
      t.references :user

      t.timestamps
    end

    add_index :pages, :status
    add_index :pages, :slug, unique: true
  end
end
