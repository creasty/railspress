class AddCropToMedia < ActiveRecord::Migration
  def change
    add_column :media, :crop_x, :integer
    add_column :media, :crop_y, :integer
    add_column :media, :crop_w, :integer
    add_column :media, :crop_h, :integer
  end
end
