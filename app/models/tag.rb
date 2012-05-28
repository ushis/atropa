require 'set'

class Tag < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  attr_accessible :tag, :slug

  validates :tag, presence: true, uniqueness: true

  has_and_belongs_to_many :videos

  before_save lambda { update_slug if tag_changed? }

  def self.from_s(str, delimiter = /,\s*/)
    tags = Set.new

    str.split(delimiter).each do |tag|
      tag.strip!
      tags << tag unless tag.empty?
    end

    tags.empty? ? [] : self.multi_find_or_initialize_by_tag(tags.to_a)
  end

  def self.multi_find_or_initialize_by_tag(tags)
    ret = self.where(tag: tags)
    ret.each { |tag| tags.delete tag.tag }
    ret + tags.collect { |tag| self.new(tag: tag) }
  end

  def self.most_popular(limit = 20)
    self.where('tags.id in (select tv.tag_id from tags_videos tv group by ' +
               'tv.tag_id order by count(tv.tag_id) DESC LIMIT ?)', limit)
  end

  def url
    tag_url id: id, slug: slug
  end

  def to_s
    tag
  end

  def as_json(options = {})
    json = super(only: [:id, :tag], methods: [:url])
    json[:videos] = videos if association(:videos).loaded?
    json
  end

  def update_slug
    self.slug = tag.parameterize
  end
end
