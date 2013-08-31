class Comment < ActiveRecord::Base

  include PublicActivity::Model
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

  #  Scope
  #-----------------------------------------------
  def self.with_ratings(user)
    user_id = user.id.to_i

    select('
      comments.*,
      coalesce(rr.total_positives, 0) as like_counts,
      coalesce(rr.total_negatives, 0) as dislike_counts,
      coalesce(rr.user_positive, 0) as user_like,
      coalesce(rr.user_negative, 0) as user_dislike
    ')
    .joins("
      left join (
        select
          r.ratable_id as comment_id,
          sum(r.positive) as total_positives,
          sum(r.negative) as total_negatives,
          max(if(r.user_id = #{user_id}, r.positive, 0)) as user_positive,
          max(if(r.user_id = #{user_id}, r.negative, 0)) as user_negative
        from ratings as r
        where r.ratable_type = 'Comment'
        group by r.ratable_id
      ) as rr
      on rr.comment_id = comments.id
    ")
    .group('comments.id')
  end

  #  Callbacks
  #-----------------------------------------------
  after_create :notify_reply
  after_create :notify_comment

  #  Kaminari
  #-----------------------------------------------
  paginates_per 10

  #  Activity
  #-----------------------------------------------
  tracked \
    except: [:update, :destroy],
    owner: ->(controller, model) { User.current_user },
    recipient: ->(controller, model) { model.post.user }

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
  def user_rating(user = nil)
    user ||= User.current_user
    @user_rating ||= {}

    @user_rating[user.id] ||= Rating
      .where(
        user_id: user.id,
        ratable_type: self.class.name,
        ratable_id: self.id,
      )
      .first_or_initialize
  end

  def like_counts
    if read_attribute(:like_counts).present?
      read_attribute(:like_counts).to_i
    else
      @ratings_totals ||= ratings.totals
      @ratings_totals.total_positives.to_i
    end
  end
  def dislike_counts
    if read_attribute(:dislike_counts).present?
      read_attribute(:dislike_counts).to_i
    else
      @ratings_totals ||= ratings.totals
      @ratings_totals.total_negatives.to_i
    end
  end

  def liked?(user = nil)
    if read_attribute(:user_like).present?
      read_attribute(:user_like).to_i == 1
    else
      user_rating(user).positive == 1
    end
  end
  def disliked?(user = nil)
    if read_attribute(:user_dislike).present?
      read_attribute(:user_dislike).to_i == 1
    else
      user_rating(user).negative == 1
    end
  end

  def like(user = nil)
    rating = user_rating user
    rating.positive = 1
    rating.negative = 0
    rating.save
  end
  def dislike(user = nil)
    rating = user_rating user
    rating.positive = 0
    rating.negative = 1
    rating.save
  end
  def unlike(user = nil)
    user_rating(user).destroy
  end

  #  Backbone JSON
  #-----------------------------------------------
  def to_json(was_created = false)
    {
      was_created: was_created,
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
      like_counts: like_counts,
      dislike_counts: dislike_counts,
      my_rating: (liked? ? 'like' : disliked? ? 'dislike' : 'none'),
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
