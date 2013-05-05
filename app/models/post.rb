# coding: utf-8

class Post < ActiveRecord::Base

  attr_accessor :thumbnail_delete, :date_str, :time_str
  attr_accessible :content, :excerpt, :status, :title, :thumbnail, :thumbnail_delete, :user_id, :created_at

  #  Association
  #-----------------------------------------------
  belongs_to :user
  has_many :comments
  has_many :metas, as: :object
  has_many :term_rels, as: :object
  has_many :terms, through: :term_rels, include: :taxonomy

  accepts_nested_attributes_for :user, allow_destroy: true
  accepts_nested_attributes_for :terms

  #  Validation
  #-----------------------------------------------
  validates :title, presence: true
  validates :status, numericality: { only_integer: true }

  #  Scope
  #-----------------------------------------------
  # default_scope where('status < ?', 2)
  scope :privated, where(status: 0)
  scope :published, where(status: 1)
  scope :trashed, where(status: 2)

  #  FriendlyId
  #-----------------------------------------------
  # extend FriendlyId
  # friendly_id :slug

  #  Kaminari
  #-----------------------------------------------
  paginates_per 10

  #  Paperclip
  #-----------------------------------------------
  has_attached_file :thumbnail,
    styles: {
      large: '1020>',
      small: '243x172#',
      facebook: '300x300#',
    },
    convert_options: {
      large: '-strip',
      small: '-quality 75 -strip',
    },
    default_url: 'http://cambelt.co/243x172'

  before_validation :destroy_thumbnail?

  #  Public Methods
  #-----------------------------------------------
  def private?
    self.status == 0
  end
  def publish?
    self.status == 1
  end

  #  Private Methods
  #-----------------------------------------------
  private

  def destroy_thumbnail?
    self.thumbnail.clear if self.thumbnail_delete == '1'
  end

end

