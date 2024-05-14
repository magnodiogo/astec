class AddAvatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string, default: 'one'
  end
end
