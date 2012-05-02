class InitAtropa < ActiveRecord::Migration

  def up
    create_table :videos do |t|
      t.integer :user_id
      t.string :vid
      t.string :title
      t.string :slug
      t.integer :width
      t.integer :height
      t.string :preview
      t.string :provider
      t.timestamps
    end

    create_table :tags do |t|
      t.string :tag
      t.string :slug
    end

    create_table :tags_videos, :id => false do |t|
      t.integer :tag_id
      t.integer :video_id
    end

    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :email
      t.string :login_hash
      t.timestamp :created_at
    end

    User.new(:username => 'ushi', :password => 'ushi', :email => 'ushi@example.com').save
  end

  def down
    drop_table :videos
    drop_table :tags
    drop_table :tags_videos
    drop_table :users
  end
end
