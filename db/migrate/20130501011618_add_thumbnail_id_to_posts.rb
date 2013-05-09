class AddThumbnailIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :thumbnail_id, :integer
  end
end
