class Term < ActiveRecord::Base

  attr_accessible :name, :slug, :taxonomy_id

  #  Association
  #-----------------------------------------------
  has_many :term_rels
  has_many :posts, through: :term_rels, source: :object, source_type: 'Post'
  has_many :pages, through: :term_rels, source: :object, source_type: 'Page'

  belongs_to :taxonomy
  accepts_nested_attributes_for :taxonomy
  accepts_nested_attributes_for :posts
  accepts_nested_attributes_for :pages

end
