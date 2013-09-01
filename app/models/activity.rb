
class Activity < ActiveRecord::Base

  attr_accessible :owner, :trackable, :recipient, :key, :parameters, :read
  serialize :parameters

  #  Association
  #-----------------------------------------------
  belongs_to :owner, polymorphic: true
  belongs_to :trackable, polymorphic: true
  belongs_to :recipient, polymorphic: true

  #  Scope
  #-----------------------------------------------
  scope :unread, -> { where read: false }
  scope :read, -> { where read: true }

  #  Public Methods
  #-----------------------------------------------
  def to_text
    op = parameters.dup
    op[:scope] = :activities
    op[:default] = ''
    I18n.t self.key, op
  end

  def to_json
    {
      id: id,
      key: key,
      text: to_text,
      timestamp: created_at.to_i,
      read: read?,
    }
  end

  #  Notify
  #-----------------------------------------------
  class << self

    def comment(comment)
      return if comment.post.user.id == comment.user.id

      create \
        key: 'comment.create',
        trackable: comment,
        owner: comment.user,
        recipient: comment.post.user,
        parameters: {
          username: comment.user.username,
          post_title: comment.post.title,
          excerpt: comment.content.strip[0..30],
        }

      NotificationMailer.delay.comment comment
    end

    def reply(comment, object_user)
      create \
        key: 'comment.reply',
        trackable: comment,
        owner: comment.user,
        recipient: object_user,
        parameters: {
          username: comment.user.username,
          excerpt: comment.content.strip[0..30],
        }

      NotificationMailer.delay.reply comment, object_user
    end

  end

end
