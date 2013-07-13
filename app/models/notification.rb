
class Notification < ActiveRecord::Base

  attr_accessible :name, :params, :user, :read
  serialize :params

  #  Association
  #-----------------------------------------------
  belongs_to :user

  #  Validation
  #-----------------------------------------------
  validate :user, presence: true
  validate :name, presence: true

  #  Scope
  #-----------------------------------------------
  scope :unread, -> { where read: false }
  scope :read, -> { where read: true }

  #  Public Methods
  #-----------------------------------------------
  def message
    op = params.merge params
    op[:scope] = :notifications
    op[:default] = ''
    I18n.t name, op
  end

  def to_json
    {
      id: id,
      name: name,
      icon: 'info',
      icon_type: 'icon',
      message: message,
      timestamp: created_at.to_i,
      read: read?,
    }
  end

  #  Notify
  #-----------------------------------------------
  class << self

    def comment(comment)
      return if comment.post.user.id == comment.user.id

      create user: comment.post.user,
        name: 'comment',
        params: {
          username: comment.user.username,
          post_title: comment.post.title,
          excerpt: comment.content.strip[0..30],
        }

      NotificationMailer.delay.comment comment
    end

    def reply(comment, object_user)
      create user: object_user,
        name: 'reply',
        params: {
          username: comment.user.username,
          excerpt: comment.content.strip[0..30],
        }

      NotificationMailer.delay.reply comment, object_user
    end

  end

end
