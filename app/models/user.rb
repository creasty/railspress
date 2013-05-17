class User < ActiveRecord::Base

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name

  #  Association
  #-----------------------------------------------
  has_many :posts, dependent: :destroy
  has_many :pages, dependent: :destroy
  has_one :oauth, dependent: :destroy
  accepts_nested_attributes_for :oauth

  #  Scope
  #-----------------------------------------------
  scope :admin, where(admin: true)

  #  Devise
  #-----------------------------------------------
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :recoverable

end
