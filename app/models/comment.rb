class Comment < ActiveRecord::Base

  include Rails.application.routes.url_helpers
  include ActionView::Helpers

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
  def to_json
    {
      id: id,
      content: content,
      by_me: user.id == User.current_user.id,
      user_path: admin_user_path(user),
      user_name: user.name,
      user_avatar: '//placehold.it/64x64',
    }
  end
  def to_thread_json
    {
      post_id: post.id,
      post_title: post.title,
      excerpt: truncate(content.strip, omission: '', length: 100),
      user_name: user.name,
      created_at: created_at.to_i,
    }
  end

end
