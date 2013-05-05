class CreateMedia < ActiveRecord::Migration

  def change
    create_table :media do |t|
      t.string :title
      t.string :description
      t.timestamps
    end
  end

  def self.up
    add_attachment :media, :asset
  end

  def self.down
    remove_attachment :media, :asset
  end

end
