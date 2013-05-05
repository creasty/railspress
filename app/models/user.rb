class User < ActiveRecord::Base

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name

  #  Association
  #-----------------------------------------------
  has_many :posts, dependent: :destroy
  has_many :pages, dependent: :destroy

  #  Devise
  #-----------------------------------------------
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :recoverable

end
