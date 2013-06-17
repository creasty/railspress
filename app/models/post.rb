# coding: utf-8

class Post < ActiveRecord::Base

  include Rails.application.routes.url_helpers

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

  def to_backbone_json
    {
      id: id,
      title: title,
      content: content,
      status: status,
      thumbnail:
        thumbnail \
        ? thumbnail.asset.url(:thumbnail)
        : '//placehold.it/243x172',
      edit_link: edit_admin_post_path(self),
      link: post_path(self),
      user_name: user.name,
      user_id: user.id,
      date_str: date_str,
      time_str: time_str,
    }
  end

  #  Attributes
  #-----------------------------------------------
  def date_str
    self.created_at ||= Time.now
    self.created_at.strftime '%Y.%m.%d'
  end
  def time_str
    self.created_at ||= Time.now
    self.created_at.strftime '%H:%M'
  end
  def date_str=(date)
    self.created_at = "#{date} #{time_str}"
  end
  def time_str=(time)
    self.created_at = "#{date_str} #{time}"
  end

end

