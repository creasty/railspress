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
  before_post_process :_transliterate_file_name

  #  Public Methods
  #-----------------------------------------------
  def avatar_from_url(url)
    self.avatar = open url
  end

  def _transliterate_file_name
    name = Digest::MD5.hexdigest self.avatar_file_name + Time.now.to_i.to_s
    self.avatar.instance_write :file_name, name
  end

end
