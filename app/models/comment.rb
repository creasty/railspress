class Comment < ActiveRecord::Base
  attr_accessible :author, :author_email, :author_ip, :content, :post

  #  Association
  #-----------------------------------------------
  belongs_to :post

  #  Validation
  #-----------------------------------------------
  validates :author, presence: true
  validates :author_email, presence: true

end
