class Rating < ActiveRecord::Base

  attr_accessible :object_type, :positive, :negative

  #  Association
  #-----------------------------------------------
  belongs_to :user
  belongs_to :object, polymorphic: true

  #  Validation
  #-----------------------------------------------
  validate :user, uniqueness: { scope: [:object_type, :object_id] }

end
