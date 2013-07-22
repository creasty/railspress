
class Setting < ActiveRecord::Base

  attr_accessible :user_id, :name, :params
  serialize :params

  #  Association
  #-----------------------------------------------
  belongs_to :user
  accepts_nested_attributes_for :user

  #  Validation
  #-----------------------------------------------
  validate :user, presence: true
  validate :name, presence: true

end
