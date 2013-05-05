class TermRel < ActiveRecord::Base

  attr_accessible :object

  #  Association
  #-----------------------------------------------
  belongs_to :object, polymorphic: true
  belongs_to :term

end
