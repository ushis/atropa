class AddGravatarId < ActiveRecord::Migration

  def up
    add_column :users, :gravatar_id, :string

    User.all.each do |user|
      user.update_gravatar_id
      user.save
    end
  end

  def down
    remove_column :users, :gravatar_id
  end
end
