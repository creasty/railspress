class Comment < ActiveRecord::Base

  include Rails.application.routes.url_helpers
  include ActionView::Helpers

  attr_accessible :content, :post

  #  Association
  #-----------------------------------------------
  belongs_to :post
  belongs_to :user
  has_many :ratings, as: :ratable, dependent: :destroy

  #  Validation
  #-----------------------------------------------
  validates :user, presence: true
  validates :content, presence: true

  #  Callbacks
  #-----------------------------------------------
  after_create :notify_reply
  after_create :notify_comment

  #  Kaminari
  #-----------------------------------------------
  paginates_per 10

  #  Markdown
  #-----------------------------------------------
  def formated_content
    options = {
      filter_html: true,
      autolink: true,
      no_intraemphasis: true,
      fenced_code: true,
      gh_blockcode: true,
    }
    settings = {
      hard_wrap: true,
      filter_html: [],
      no_images: true,
      no_styles: true,
    }
    renderer = Redcarpet::Render::HTML.new settings
    md = Redcarpet::Markdown.new renderer, options
    md = md.render(content).html_safe
  end

  #  Like / Dislike
  #-----------------------------------------------
  def user_rating(user)
    Rating
    .where(
      user_id: user.id,
      ratable_type: self.class.name,
      ratable_id: self.id,
    )
    .first_or_initialize
  end
  def like(user)
    rating = user_rating user
    rating.positive = 1
    rating.negative = 0
    rating.save
  end
  def dislike(user)
    rating = user_rating user
    rating.positive = 0
    rating.negative = 1
    rating.save
  end
  def unlike(user)
    user_rating(user).destroy
  end

  #  Backbone JSON
  #-----------------------------------------------
  def to_json(was_created = false)
    {
      id: id,
      post_id: post.id,
      content: content,
      markdown: formated_content,
      by_me: user.id == User.current_user.id,
      user_path: edit_admin_user_path(user),
      user_name: user.name,
      user_username: user.username,
      user_avatar: user.avatar_url,
      timestamp: created_at.to_i,
      was_created: was_created,
    }
  end

  def to_thread_json
    {
      id: post.id,
      post_title: post.title,
      excerpt: truncate(content.strip, omission: '', length: 100),
      user_name: user.name,
      timestamp: created_at.to_i,
    }
  end


private

  #  Notifications
  #-----------------------------------------------
  def notify_comment
    Notification.comment self
  end

  def notify_reply
    object_users = content.scan(/\@(\w+?)\b/)

    return if object_users.length == 0

    object_users.each do |object_user|
      object_user = User.find_by_username object_user[0]
      Notification.reply self, object_user
    end
  end

end
