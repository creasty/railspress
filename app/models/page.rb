class Page < ActiveRecord::Base

  attr_accessible :content, :excerpt, :status, :title, :slug

  #  Association
  #-----------------------------------------------
  belongs_to :user
  has_many :metas, as: :object
  has_many :terms, as: :object, through: :term_rels

  #  Validation
  #-----------------------------------------------
  validates :title, presence: true

  #  FriendlyId
  #-----------------------------------------------
  extend FriendlyId
  friendly_id :slug

end
