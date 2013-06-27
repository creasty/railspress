class Comment < ActiveRecord::Base

  include Rails.application.routes.url_helpers

  attr_accessible :content, :post

  #  Association
  #-----------------------------------------------
  belongs_to :post
  belongs_to :user

  #  Validation
  #-----------------------------------------------
  validates :post, presence: true
  validates :user, presence: true
  validates :content, presence: true

  #  Public Methods
  #-----------------------------------------------
  def to_backbone_json
    {
      id: id,
      content: content,
      by_me: user.id == current_user.id,
      user_path: admin_user_path(user),
      user_name: user.name,
      user_avatar: '//placehold.it/64x64',
    }
  end

end
