class Taxonomy < ActiveRecord::Base

  attr_accessible :name, :multiple

  #  Association
  #-----------------------------------------------
  has_many :terms

end
