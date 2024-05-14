class UsersPrimeiroAcesso < ActiveRecord::Migration
  def self.up    
     add_column :users, :primeiro_acesso, :boolean
  end

  def self.down
     remove_column :users, :primeiro_acesso
  end
end
