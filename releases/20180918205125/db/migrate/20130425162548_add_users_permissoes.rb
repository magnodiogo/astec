class AddUsersPermissoes < ActiveRecord::Migration
  def self.up
     add_column :users, :master,           :boolean
     add_column :users, :add_atividade,    :boolean
     add_column :users, :edit_atividade,   :boolean
     add_column :users, :edit_imobiliaria, :boolean
     add_column :users, :new_imobiliaria,  :boolean
     add_column :users, :bloqueia_imobiliaria, :boolean
  end

  def self.down
     remove_column :users, :master
     remove_column :users, :add_atividade
     remove_column :users, :edit_atividade
     remove_column :users, :edit_imobiliaria
     remove_column :users, :new_imobiliaria
     remove_column :users, :bloqueia_imobiliaria
  end
end
