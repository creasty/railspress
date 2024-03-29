class CreateOauths < ActiveRecord::Migration
  def change
    create_table :oauths do |t|
      t.integer :user_id

      t.string :uid, null: false
      t.string :provider, null: false

      t.string :token
      t.string :token_expires_at
      t.string :token_secret

      t.string :avatar_file_name
      t.string :avatar_content_type
      t.integer :avatar_file_size

      t.timestamps
    end

    add_index :oauths, :uid, unique: true
    add_index :oauths, :user_id
  end
end
