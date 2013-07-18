class Rating < ActiveRecord::Base

  attr_accessible :positive, :negative
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

  #  Scope
  #-----------------------------------------------
  scope :positives, -> { where 'positive > 0' }
  scope :negatives, -> { where 'negative > 0' }
  scope :totals, -> { select 'sum(positive) as total_positives, sum(negative) as total_negatives' }

end
