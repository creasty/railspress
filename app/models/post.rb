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

  def self.sort(order_by, dir)
    order_by = order_by.present? ? order_by.gsub(/\W/, '') : 'created_at'
    dir = (dir == 'asc') ? dir : 'desc'
    order "#{order_by} #{dir}"
  end

  def self.search(params)
    q = ['1 = 1']

    if params.try(:[], :user_id).present?
      q[0] << ' and user_id = ?'
      q << params[:user_id]
    end
    if params.try(:[], :status).present?
      q[0] << ' and status = ?'
      q << params[:status]
    end
    if params.try(:[], :title).present?
      q[0] << ' and title like ?'
      q << "%#{params[:title]}%"
    end

    where q
  end

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

