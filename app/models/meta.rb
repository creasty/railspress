class Meta < ActiveRecord::Base

  attr_accessible :key, :value

  #  Association
  #-----------------------------------------------
  belongs_to :object, polymorphic: true

end
