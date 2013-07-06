
class Notification < ActiveRecord::Base

  attr_accessible :notification_topic, :params, :user, :read

  #  Association
  #-----------------------------------------------
  belongs_to :notification_topic
  belongs_to :user

  #  Scope
  #-----------------------------------------------
  scope :unread, -> { where read: false }
  scope :read, -> { where read: true }

  #  Public Methods
  #-----------------------------------------------
  def message
    op = params.present? ? ActiveSupport::JSON.decode(params) : {}
    op.symbolize_keys!
    op[:scope] = :notifications
    op[:default] = ''
    I18n.t notification_topic.name, op
  end

  def to_json
    {
      id: id,
      name: notification_topic.name,
      icon: 'info',
      icon_type: 'icon',
      message: message,
      timestamp: created_at.to_i,
      read: read?,
    }
  end

end
