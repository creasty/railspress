class AddMediaIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :media_id, :integer
  end
end
