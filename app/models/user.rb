class User < ActiveRecord::Base

  include Rails.application.routes.url_helpers

  attr_accessible :email, :password, :password_confirmation, :remember_me, :admin, :name

  attr_readonly :sign_in_count, :current_sign_in_at, :current_sign_in_ip, :last_sign_in_at, :last_sign_in_ip

  #  Association
  #-----------------------------------------------
  has_many :posts, dependent: :destroy
  has_many :pages, dependent: :destroy
  has_many :oauths, dependent: :destroy
  accepts_nested_attributes_for :oauths

  #  Scope
  #-----------------------------------------------
  scope :admin, where(admin: true)

  def self.sort(order_by, dir)
    order_by = order_by.present? ? order_by.gsub(/\W/, '') : 'created_at'
    dir = (dir == 'asc') ? dir : 'desc'
    order "#{order_by} #{dir}"
  end

  def self.search(params)
    q = ['1 = 1']

    if params.try(:[], :name).present?
      q[0] << ' and name like ?'
      q << "%#{params[:name]}%"
    end
    if params.try(:[], :admin).present?
      q[0] << ' and admin = ?'
      q << params[:admin]
    end

    where q
  end

  #  Devise
  #-----------------------------------------------
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :recoverable

  #  Kaminari
  #-----------------------------------------------
  paginates_per 10

  #  Public Methods
  #-----------------------------------------------
  def to_backbone_json
    {
      id: id,
      name: name,
      admin: admin?,
      avatar: avatar_url,
      edit_link: edit_admin_user_path(self),
      date: self.created_at.strftime('%Y.%m.%d %H:%M')
    }
  end

  def avatar_url(size = 48)
    gravatar_id = Digest::MD5.hexdigest self.email.downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=identicon"
  end

  def facebook?
    oauths.exists? provider: 'facebook'
  end

  def twitter?
    oauths.exists? provider: 'twitter'
  end

  def facebook
    oauths.where(provider: 'facebook').first
  end

  def twitter
    oauths.where(provider: 'twitter').first
  end

end
