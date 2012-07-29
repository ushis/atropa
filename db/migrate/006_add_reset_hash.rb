class AddResetHash < ActiveRecord::Migration
  def up
    add_column :users, :password_reset_hash, :string, null: true
    add_column :users, :password_reset_set_at, :datetime

    add_index :users, :password_reset_hash, unique: true
  end

  def down
    remove_column :users, :password_reset_hash
    remove_column :users, :password_reset_set_at
  end
end
