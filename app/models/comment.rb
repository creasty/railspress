class Comment < ActiveRecord::Base
  attr_accessible :content, :post, :user, :user_id

  #  Association
  #-----------------------------------------------
  belongs_to :post
  belongs_to :user

  #  Validation
  #-----------------------------------------------
  validates :content, presence: true

end
