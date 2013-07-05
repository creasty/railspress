
class Notification < ActiveRecord::Base

  attr_accessible :notification_topic, :params, :user, :read

  #  Association
  #-----------------------------------------------
  belongs_to :notification_topic
  belongs_to :user

  #  Scope
  #-----------------------------------------------
  scope :unread, -> { where read: 0 }
  scope :read, -> { where read: 1 }

end
