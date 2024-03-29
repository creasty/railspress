class Oauth < ActiveRecord::Base

  attr_accessible :uid, :provider, :token, :token_secret, :token_expires_at, :avatar, :user_id

  #  Association
  #-----------------------------------------------
  belongs_to :user

  #  Validation
  #-----------------------------------------------
  validates_presence_of :provider, :uid
  validates_uniqueness_of :uid

  #  Paperclip
  #-----------------------------------------------
  has_attached_file :avatar,
    default_url: 'http://placehold.it/200x200'

  #  Public Methods
  #-----------------------------------------------
  def avatar_from_url(url)
    self.avatar = open url
  end

end
