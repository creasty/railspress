class Taxonomy < ActiveRecord::Base

  attr_accessible :name, :parent

  #  Association
  #-----------------------------------------------
  has_many :terms

end
