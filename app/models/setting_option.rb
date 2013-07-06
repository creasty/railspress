class SettingOption < ActiveRecord::Base

  attr_accessible :name

  #  Association
  #-----------------------------------------------
  has_many :settings, dependent: :destroy

  #  Validation
  #-----------------------------------------------
  validates :name, presence: true
  validates_uniqueness_of :name

end
