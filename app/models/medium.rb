class Medium < ActiveRecord::Base

  attr_accessor :asset_delete
  attr_accessible :title, :description, :asset, :asset_delete

  #  Validation
  #-----------------------------------------------
  validate :title, presence: true
  validate :asset, presence: true

  #  Paperclip
  #-----------------------------------------------
  # attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessible :crop_x, :crop_y, :crop_w, :crop_h

  has_attached_file :asset,
    styles: {
      large: '1020>',
      small: '243x172#',
      facebook: '300x300#',
      cropped: { geometry: '', processors: [:cropper] }
    },
    convert_options: {
      large: '-strip',
      small: '-quality 75 -strip',
    },
    default_url: 'http://cambelt.co/243x172'

  # before_post_process :skip_for_non_image
  # before_post_process :rename_image, unless: :cropping?
  before_validation :destroy?
  # after_update :reprocess_image, if: :cropping?

  def cropping?
    !crop_x.blank? &&
    !crop_y.blank? &&
    !crop_w.blank? &&
    !crop_h.blank?
  end

  #  Private Methods
  #-----------------------------------------------
  private

  def skip_for_non_image
    !%w[image/jpeg image/jpg image/png image/gif].include?(asset.content_type)
  end

  def reprocess_image
    asset.reprocess!
  end

  def rename_image
    self.asset.instance_write :file_name, "#{Time.now.to_i.to_s}_#{SecureRandom.hex(10)}.jpg"
  end

  def destroy?
    self.asset.clear if self.asset_delete == '1'
  end

end
