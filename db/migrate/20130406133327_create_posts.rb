class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :status, defualt: 0
      t.string :title
      t.string :excerpt
      t.text :content
      t.references :user

      t.timestamps
    end

    add_index :posts, :status
  end
end
