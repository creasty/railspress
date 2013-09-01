# coding: utf-8

class Post < ActiveRecord::Base

  include Rails.application.routes.url_helpers

  attr_accessor :date_str, :time_str
  attr_accessible :content, :excerpt, :status, :title, :thumbnail_id, :user_id, :created_at, :date_str, :time_str, :tag_list

  #  Association
  #-----------------------------------------------
  acts_as_taggable

  belongs_to :user
  belongs_to :thumbnail, class_name: '::Medium'
  has_many :comments, dependent: :destroy
  has_many :ratings, as: :ratable, dependent: :destroy
  has_many :activities, as: :trackable, dependent: :destroy

  accepts_nested_attributes_for :user, allow_destroy: true

  #  Validation
  #-----------------------------------------------
  validates :status, numericality: { only_integer: true }
  validates :title, presence: true
  validates :user_id, numericality: true

  #  Callbacks
  #-----------------------------------------------
  after_create :activity_create
  after_update :activity_update
  before_destroy :activity_destroy

  #  Scope
  #-----------------------------------------------
  scope :private, -> { where status: 0 }
  scope :published, -> { where status: 1 }

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

  def to_json
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
    self.created_at.strftime '%Y.%m.%d' if self.created_at.present?
  end
  def time_str
    self.created_at.strftime '%H:%M' if self.created_at.present?
  end
  def date_str=(date)
    self.created_at = "#{date} #{time_str}"
  end
  def time_str=(time)
    self.created_at = "#{date_str} #{time}"
  end


private


  #  Notifications
  #-----------------------------------------------
  def activity_create
    record_activity 'create'
  end
  def activity_update
    record_activity 'update'
  end
  def activity_destroy
    record_activity 'destroy'
  end

  def record_activity(action)
    Activity.create \
      key: "post.#{action}",
      trackable: self,
      owner: self.user
  end

end
