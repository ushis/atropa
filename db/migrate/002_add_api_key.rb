class AddApiKey < ActiveRecord::Migration

  def up
    add_column :users, :api_key, :string, null: true

    User.all.each { |user| user.refresh_api_key! }
  end

  def down
    remove_column :users, :api_key
  end
end
