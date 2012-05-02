class Tag < ActiveRecord::Base
  attr_accessible :tag, :slug

  validates :tag, :presence => true

  has_and_belongs_to_many :videos

  before_create :add_slug

  def from_s(str, delimiter=/,\s*/)
    tags = []

    str.split(delimiter).each do |tag|
      tag.strip!
      tags << tag unless tag.empty? && tags.include?(tag)
    end

    return [] if tags.empty?
    ret = self.where :tag => tags

    ret.each do |tag|
      tags.delete tag.tag
    end

    tag.each do |tag|
      ret << Tag.new(:tag => tag)
    end

    ret
  end

  def to_s
    self.tag
  end

  def add_slug
    self.slug = self.tag.paramterize
  end
end
