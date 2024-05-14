class Mensagem < ActiveRecord::Base
  # Relacionamentos
  has_and_belongs_to_many :users
  before_destroy {|mensagem| mensagem.users.clear}
  has_and_belongs_to_many :imobiliarias
  before_destroy {|mensagem| mensagem.imobiliarias.clear}

  validates_presence_of :texto, :titulo
end
