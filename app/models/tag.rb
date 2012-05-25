require 'set'

class Tag < ActiveRecord::Base
  attr_accessible :tag, :slug

  validates :tag, presence: true

  has_and_belongs_to_many :videos

  before_create :add_slug

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

  def self.not_orphaned
    self.where('tags.id in (select tv.tag_id from tags_videos tv)')
  end

  def to_s
    self.tag
  end

  def add_slug
    self.slug = self.tag.parameterize
  end
end
