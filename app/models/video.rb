class Video < ActiveRecord::Base
  attr_accessible :vid, :title, :slug, :width, :height, :preview, :provider

  validates :title, presence: true
  validates :vid, presence: true

  belongs_to :user
  has_and_belongs_to_many :tags

  before_create :add_slug

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

  def add_slug
    self.slug = self.title.parameterize
  end
end
