class InitAtropa < ActiveRecord::Migration

  def up
    create_table :videos do |t|
      t.integer :user_id,  null: false
      t.string  :vid,      null: false
      t.string  :title,    null: false
      t.string  :slug,     null: false
      t.integer :width,    null: false
      t.integer :height,   null: false
      t.string  :preview,  null: false
      t.string  :provider, null: false
      t.timestamps
    end

    create_table :tags do |t|
      t.string :tag,  null: false
      t.string :slug, null: false
    end

    create_table :tags_videos, :id => false do |t|
      t.integer :tag_id,   null: false
      t.integer :video_id, null: false
    end

    create_table :users do |t|
      t.string :username,        null: false
      t.string :password_digest, null: false
      t.string :email,           null: false
      t.string :login_hash,      null: true
      t.timestamp :created_at,   null: false
    end
  end

  def down
    drop_table :videos
    drop_table :tags
    drop_table :tags_videos
    drop_table :users
  end
end
