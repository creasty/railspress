class Rating < ActiveRecord::Base

  attr_accessible :positive, :negative, :total_positives, :total_positives
  attr_readonly :ratable_id, :ratable_type

  #  Association
  #-----------------------------------------------
  belongs_to :user
  belongs_to :ratable, polymorphic: true

  accepts_nested_attributes_for :user

  #  Validation
  #-----------------------------------------------
  validate :ratable, presence: true
  validate :user,
    presence: true,
    uniqueness: { scope: [:ratable_type, :ratable_id] }

  #  Callbacks
  #-----------------------------------------------
  after_create :notify_rating

  #  Scope
  #-----------------------------------------------
  scope :positives, -> { where 'positive > 0' }
  scope :negatives, -> { where 'negative > 0' }

  def self.totals
    select('
      sum(positive) as total_positives,
      sum(negative) as total_negatives
    ')
    .first
  end


private


  #  Notifications
  #-----------------------------------------------
  def notify_rating
    Activity.create \
      key: "#{ratable.class.name.downcase}.rating.create",
      trackable: self,
      owner: self.user,
      recipient: self.ratable.user

    NotificationMailer.delay.rating self
  end

end
