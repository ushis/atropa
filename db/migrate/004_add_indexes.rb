class AddIndexes < ActiveRecord::Migration

  def up
    add_index :users,  :username,         unique: true
    add_index :users,  :email,            unique: true
    add_index :users,  :login_hash,       unique: true
    add_index :tags,   :tag,              unique: true
    add_index :videos, [:vid, :provider], unique: true
  end

  def down
    remove_index :users,  column: :username
    remove_index :users,  column: :email
    remove_index :users,  column: :login_hash
    remove_index :tags,   column: :tag
    remove_index :videos, column: [:vid, :provider]
  end
end
