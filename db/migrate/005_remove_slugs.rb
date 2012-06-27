class RemoveSlugs < ActiveRecord::Migration

  def up
    remove_column :videos, :slug
    remove_column :tags, :slug
  end

  def down
    add_column :videos, :slug, :string, null: false
    add_column :tags, :slug, :string, null: false

    Video.all.each { |v| v.slug = v.title.parameterize; v.save }
    Tag.all.each { |t| t.slug = t.tag.parameterize; t.save }
  end
end
