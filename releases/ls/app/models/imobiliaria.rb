class Imobiliaria < ActiveRecord::Base
  self.table_name = 'imobiliarias'

  # Relacionamentos
  has_many :users, dependent: :destroy
  has_many :documentos
  has_many :seguros
  has_and_belongs_to_many :mensagens
  before_destroy {|imobiliaria| imobiliaria.mensagens.clear}

  # Validações
  validates_presence_of :cpf_cnpj, :nome_fantasia, :estipulante, :cidade, :estado
  validates_presence_of :data_nascimento, if: Proc.new { |s| s.tipo_pessoa == 'F' }, :message => " é obrigatório para Pessoa Fisica."
  validates_presence_of :ie_rg,           if: Proc.new { |s| s.tipo_pessoa == 'F' }, :message => " é obrigatório para Pessoa Fisica."
  validates_presence_of :data_expedicao,  if: Proc.new { |s| s.tipo_pessoa == 'F' }, :message => " é obrigatório para Pessoa Fisica."
 
  def tipo_pessoa_desc
    case self.tipo_pessoa
      when 'J' then 'Jurídica'
      else
        'Física'
    end
  end

  def bloqueia!
    self.bloqueada ||= false
    self.bloqueada   = (self.bloqueada == false)
    self.save!
  end
end
