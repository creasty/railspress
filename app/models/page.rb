class Page < ActiveRecord::Base

  attr_accessible :content, :excerpt, :status, :title, :slug

  #  Association
  #-----------------------------------------------
  acts_as_taggable

  belongs_to :user

  #  Validation
  #-----------------------------------------------
  validates :title, presence: true
  validates_uniqueness_of :slug

  #  FriendlyId
  #-----------------------------------------------
  extend FriendlyId
  friendly_id :slug

end
