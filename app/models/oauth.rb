class Oauth < ActiveRecord::Base

  attr_accessible :uid, :provider, :token, :token_secret, :token_expires_at, :avatar, :user_id

  require 'open-uri'

  #  Association
  #-----------------------------------------------
  belongs_to :user
  has_many :entries

  #  Validation
  #-----------------------------------------------
  validates_presence_of :provider, :uid
  validates_uniqueness_of :uid

  #  Paperclip
  #-----------------------------------------------
  has_attached_file :avatar

  #  Public Methods
  #-----------------------------------------------
  def avatar_from_url(url)
    self.avatar = open url
  end

end
