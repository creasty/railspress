class Medium < ActiveRecord::Base

  include Rails.application.routes.url_helpers

  attr_accessor :asset_delete, :processing, :content_type, :file_name
  attr_accessible :title, :description, :asset
  attr_accessible :asset_delete, :content_type, :file_name,
    :crop_x, :crop_y, :crop_w, :crop_h

  #  Validation
  #-----------------------------------------------
  validate :title, presence: true
  validate :asset,
    presence: true,
    attachment_size: { less_than: 20.megabyte }

  #  General Callbacks
  #-----------------------------------------------
  before_validation :generate_title

  #  Paperclip
  #-----------------------------------------------
  has_attached_file :asset,
    styles: {
      large: '1020>',
      thumbnail: '243x172#',
      small: '300x300>',
      facebook: '300x300#',
      cropped: { geometry: '', processors: [:cropper] },
    },
    convert_options: {
      large: '-strip',
      thumbnail: '-quality 75 -strip',
    },
    default_url: 'http://placehold.it/243x172',
    url: '/system/:class/:id_partition/:style.:extension',
    path: ':rails_root/public:url'

  before_validation :destroy?
  # before_validation :fix_crop_coord
  # before_post_process :rename_image
  before_post_process :image?
  after_save :check_file
  after_update :reprocess_image

  #  Kaminari
  #-----------------------------------------------
  paginates_per 20

  #  Public Methods
  #-----------------------------------------------
  def cropping?
    !crop_x.blank? &&
    !crop_y.blank? &&
    !crop_w.blank? &&
    !crop_h.blank?
  end

  def image?
    %w[image/jpeg image/jpg image/png image/gif].include?(content_type || asset.content_type)
  end

  def file_type
    type = content_type || asset.content_type

    return 'pdf' if type == 'application/pdf'

    type.split('/')[0]
  end

  def to_json
    {
      id: id,
      title: title,
      description: description,
      file_name: read_attribute(:asset_file_name),
      file_size: read_attribute(:asset_file_size),
      file_type: file_type,
      thumbnail: asset.url(:small),
      link: asset.url,
      is_image: image?,
      crop_x: crop_x,
      crop_y: crop_y,
      crop_w: crop_w,
      crop_h: crop_h,
    }
  end


private


  #  Private Methods
  #-----------------------------------------------
  def generate_title
    unless self.title.present?
      title = file_name || asset_file_name.dup
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

  def check_file
    if read_attribute(:asset_file_name).nil?
      self.destroy
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

  def destroy?
    self.asset.clear if self.asset_delete == '1'
  end

end
