class UserAddColumnAdminCorretora < ActiveRecord::Migration
  def self.up
     add_column :users, :admin_corretora, :boolean
  end

  def self.down
     remove_column :users, :admin_corretora
  end
end
