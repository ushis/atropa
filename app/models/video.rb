require 'videourl'

class Video < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  attr_accessible :vid, :title, :slug, :width, :height, :preview, :provider

  validates :title, presence: true
  validates :vid,   presence: true
  validates :vid,   uniqueness: {scope: :provider}

  belongs_to :user
  has_and_belongs_to_many :tags

  before_save lambda { update_slug if title_changed? }

  def self.new_from_url(url)
    new VideoUrl.video_info(url)
  end

  def self.most_recent(page = 1, per_page = 6)
    paginate(page: page, per_page: per_page).order('created_at DESC')
  end

  def self.search(q, page = 1, per_page = 6)
    videos = most_recent(page, per_page)

    return videos if q.blank?

    finder = self
    conditions = 'videos.title like :q'

    if videos.includes_values.include?(:tags)
      finder = finder.joins(:tags)
      conditions << ' or tags.tag like :q'
    end

    videos.where(id: finder.where(conditions, q: "%#{q}%").pluck('videos.id'))
  end

  def similar(limit = 4)
    Video.where('videos.id in (
                   select tv.video_id
                   from tags_videos tv
                   where tv.tag_id in (
                     select _tv.tag_id
                     from tags_videos _tv
                     where _tv.video_id = :id
                   )
                   and tv.video_id != :id
                   group by tv.video_id
                   order by count(tv.tag_id) desc
                   limit :limit
                 )', id: id, limit: limit)
  end

  def url
    video_url id: id, slug: slug
  end

  def link
    VideoUrl.video_url provider, vid
  end

  def source
    VideoUrl.video_src provider, vid
  end

  def as_json(options = {})
    json = super(only: [:id, :title, :preview, :created_at], methods: [:url, :link, :source])
    json[:user] = user if association(:user).loaded?
    json[:tags] = tags if association(:tags).loaded?
    json
  end

  def update_slug
    self.slug = title.parameterize
  end
end
