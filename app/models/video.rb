class Video < ActiveRecord::Base
  attr_accessible :title, :slug, :width, :height, :preview, :provider

  validates :title, :presence => true
  validates :vid, :presence => true

  belongs_to :user
  has_and_belongs_to_many :tags

  before_create :add_slug

  def self.paginate(page, per_page = 10)
    total = self.count
    info = {:total => (total / per_page.to_f).ceil}

    if page > info[:total]
      info[:current] = info[:total]
    elsif page < 1
      info[:current] = 1
    else
      info[:current] = page
    end

    [self.includes(:tags).order('videos.created_at DESC').limit(per_page)
     .offset((info[:current] -1) * per_page).all, info]
  end

  def add_slug
    self.slug = self.title.parameterize
  end
end