
class Setting < ActiveRecord::Base

  attr_accessible :user_id, :setting_option_id, :params
  serialize :params

  #  Association
  #-----------------------------------------------
  belongs_to :setting_option
  belongs_to :user
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :setting_option

end
