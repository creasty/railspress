
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
    op = parameters.nil? ? {} : parameters.dup
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

end
