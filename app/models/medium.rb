class Medium < ActiveRecord::Base

  include Rails.application.routes.url_helpers

  attr_accessor :asset_delete, :processing
  attr_accessible :title, :description, :asset, :asset_delete
  attr_accessible :crop_x, :crop_y, :crop_w, :crop_h

  #  Validation
  #-----------------------------------------------
  validate :title, presence: true
  validate :asset, presence: true

  #  General Callbacks
  #-----------------------------------------------
  before_validation :generate_title

  #  Paperclip
  #-----------------------------------------------
  has_attached_file :asset,
    styles: {
      large: '1020>',
      small: '243x172#',
      facebook: '300x300#',
      cropped: { geometry: '', processors: [:cropper] }
    },
    convert_options: {
      large: '-strip',
      small: '-quality 75 -strip'
    },
    default_url: 'http://placehold.it/243x172',
    url: '/system/:class/:id_partition/:style.:extension',
    path: ':rails_root/public:url'

  before_validation :destroy?
  # before_validation :fix_crop_coord
  # before_post_process :rename_image
  before_post_process :image?
  after_update :reprocess_image

  #  Public Methods
  #-----------------------------------------------
  def cropping?
    !crop_x.blank? &&
    !crop_y.blank? &&
    !crop_w.blank? &&
    !crop_h.blank?
  end

  def image?
    %w[image/jpeg image/jpg image/png image/gif].include? asset.content_type
  end

  def file_type
    asset.content_type.split('/')[0].capitalize
  end

  def to_backbone_json
    {
      id: id,
      title: title,
      description: description,
      name: read_attribute(:asset_file_name),
      size: read_attribute(:asset_file_size),
      file_type: file_type,
      thumbnail: asset.url(:small),
      is_image: image?,
      # delete_url: admin_medium_path(self),
    }
  end


  #  Private Methods
  #-----------------------------------------------
  private

  def generate_title
    unless self.title.present?
      title = self.asset_file_name.dup
      title.gsub!(/\.\w+$/, '')
      title.gsub!(/[\']/, '')
      title.gsub!('&', ' and ')
      title.gsub!('@', ' at ')
      title.gsub!(/[^a-z0-9]+/i, ' ')
      title.gsub!(/\s+/, ' ')
      title.strip!
      title.capitalize!

      self.title = title
    end
  end

  def reprocess_image
    return unless cropping? && !processing

    self.processing = true
    asset.reprocess!
    self.processing = false
  end

  def image_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(self.asset.path(style))
  end

  def fix_crop_coord
    ratio = image_geometry(:original).width /
      image_geometry(:large).width

    self.crop_x = (self.crop_x * ratio).truncate
    self.crop_y = (self.crop_y * ratio).truncate
    self.crop_w = (self.crop_w * ratio).truncate
    self.crop_h = (self.crop_h * ratio).truncate
  end

  def rename_image
    hash = Digest::SHA1.hexdigest "#{Time.now.to_i.to_s}#{SecureRandom.hex(10)}"
    ext = File.extname(asset_file_name).downcase
    self.asset.instance_write :file_name, "#{hash}#{ext}"
  end

  def destroy?
    self.asset.clear if self.asset_delete == '1'
  end

end
