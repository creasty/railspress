# coding: utf-8

class Post < ActiveRecord::Base

  attr_accessor :date_str, :time_str, :tags
  attr_accessible :content, :excerpt, :status, :title, :thumbnail_id, :user_id, :created_at, :date_str, :time_str, :tags

  #  Association
  #-----------------------------------------------
  belongs_to :user
  has_many :comments
  has_many :metas, as: :object
  has_many :term_rels, as: :object
  has_many :terms, through: :term_rels, include: :taxonomy
  belongs_to :thumbnail, class_name: '::Medium'

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

  #  Public Methods
  #-----------------------------------------------
  def private?
    self.status == 0
  end
  def publish?
    self.status == 1
  end

end

