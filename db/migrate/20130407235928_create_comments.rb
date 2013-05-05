class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :author, default: ''
      t.string :author_email, null: false
      t.string :author_ip, null: false
      t.text :content
      t.references :post

      t.timestamps
    end
  end
end
