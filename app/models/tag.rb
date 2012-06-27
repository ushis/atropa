require 'set'

class Tag < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  attr_accessible :tag

  validates :tag, presence: true, uniqueness: true

  has_and_belongs_to_many :videos

  def self.from_s(str, delimiter = /,\s*/)
    tags = Set.new

    str.split(delimiter).each do |tag|
      tag.strip!
      tags << tag unless tag.empty?
    end

    tags.empty? ? [] : multi_find_or_initialize_by_tag(tags.to_a)
  end

  def self.multi_find_or_initialize_by_tag(tags)
    ret = where(tag: tags).each { |tag| tags.delete tag.tag }
    ret + tags.collect { |tag| self.new(tag: tag) }
  end

  def self.most_popular(limit = 20)
    where('tags.id in (select tv.tag_id from tags_videos tv group by
           tv.tag_id order by count(tv.tag_id) desc limit ?)', limit)
  end

  def self.all_with_usage
    select('tags.id, tags.tag, count(tv.tag_id) vcount')
    .joins('join tags_videos tv on tv.tag_id = tags.id')
    .group('tags.id')
  end

  def most_recent_videos(page = 1, per_page = 6)
    Video.most_recent(page, per_page).where('videos.id in (select tv.video_id from
                                             tags_videos tv where tv.tag_id = ?)', id)
  end

  def slug
    tag.parameterize
  end

  def url
    tag_url id: id, slug: slug
  end

  def to_s
    tag
  end

  def as_json(options = {})
    json = super(only: [:id, :tag, :vcount], methods: [:url])
    json[:videos] = videos if association(:videos).loaded?
    json
  end
end
