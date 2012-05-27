require 'videourl'

class Video < ActiveRecord::Base
  attr_accessible :vid, :title, :slug, :width, :height, :preview, :provider

  validates :title, presence: true
  validates :vid, presence: true

  belongs_to :user
  has_and_belongs_to_many :tags

  before_save :update_slug

  def self.new_from_url(url)
    self.new VideoUrl.video_info(url)
  end

  def self.paginate(page, options = {})
    opts = {per_page: 10, order: 'created_at DESC'}.update(options)

    query = self
    query = query.includes(*opts[:includes]) if opts[:includes]
    opts[:conditions].each { |col, val| query = query.where(col, val) } if opts[:conditions]
    total = query.count.fdiv(opts[:per_page]).ceil

    return [[], {total: 0, current: 1}] if total == 0

    if page > total
      page = total
    elsif page < 1
      page = 1
    end

    [query.order(opts[:order]).limit(opts[:per_page]).offset((page - 1) * opts[:per_page]).all,
     {total: total, current: page}]
  end

  def url
    VideoUrl.video_url provider, vid
  end

  def source
    VideoUrl.video_src provider, vid
  end

  def as_json(options = {})
    json = super(only: [:id, :title, :preview, :created_at])
    json[:user] = user if association(:user).loaded?
    json[:tags] = tags if association(:tags).loaded?
    json
  end

  def update_slug
    self.slug = title.parameterize
  end
end
