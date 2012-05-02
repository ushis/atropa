class Video < ActiveRecord::Base
  attr_accessible :title, :slug, :width, :height, :preview, :provider

  validates :title, :presence => true
  validates :vid, :presence => true

  belongs_to :user
  has_and_belongs_to_many :tags

  before_create :add_slug

  def add_slug
    self.slug = self.title.parameterize
  end
end
