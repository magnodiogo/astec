class Titulo < ActiveRecord::Base
  require "#{Rails.root}/lib/valida_cpf_cnpj.rb"
  include ValidaCpfCnpj

  belongs_to :user
  belongs_to :imobiliaria
  belongs_to :logradouro, foreign_key: :cep, primary_key: :cep
  #
  validates_presence_of :user, :imobiliaria
  validates_presence_of :finalidade_do_imovel, :tipo_do_imovel, :valor_locacao
  validates_presence_of :cep, :logradouro, :numero
  validates_presence_of :locatario_nome, :locatario_tipo, :locatario_cpf_cnpj, :locatario_telefone, :locatario_email
  validates_presence_of :locador_nome, :locador_tipo, :locador_cpf_cnpj, :valor_titulo, :meses_do_titulo, :multiplicador_do_titulo
  validates_presence_of :complemento, if: Proc.new {|t| %w(A B F S).include?(t.tipo_do_imovel)}, message: " é obrigatório para este tipo de imóvel."
  # Locatario sendo Pessoa Fisica
  validates_presence_of :locatario_data_nascimento, :locatario_rg, :locatario_orgao_emissor,    if: Proc.new {|t| t.locatario_tipo == 'PF'}, message: " é obrigatório."
  validates_presence_of :locatario_data_expedicao,  :locatario_profissao,                       if: Proc.new {|t| t.locatario_tipo == 'PF'}, message: " é obrigatório."
  # Locatario sendo Pessoa Jurídica
  validates_presence_of :responsavel_legal_nome, :responsavel_legal_rg,                         if: Proc.new {|t| t.locatario_tipo == 'PJ'}, message: " é obrigatório."
  validates_presence_of :locatario_atividade, :responsavel_legal_cpf,                           if: Proc.new {|t| t.locatario_tipo == 'PJ'}, message: " é obrigatório."

  validate :validar_cpf_cnpj
  validate :validar_numero
  validate :validar_complemento
  after_create :enviar_email

  def endereco_formatado
    retorno = ''
    if self.logradouro
      retorno = self.logradouro.endereco + ', ' + self.numero
      retorno << ' ' + self.complemento unless self.complemento.blank?
    end
    retorno
  end

  def multiplicador_do_titulo_desc
    case self.multiplicador_do_titulo
      when 'M' then 'Multiplos por Aluguel'
      when 'A' then 'Aluguel mais Encargos'
    end
  end

  def finalidade_do_imovel_desc
    case self.finalidade_do_imovel
      when "R" then "Residencial"
      when "E" then "Empresarial"
      when "V" then "Veraneio"
      when "O" then "Outros"
      else 
        "Não definido."
    end
  end

  def tipo_do_imovel_desc
    case self.tipo_do_imovel
      when "A"  then "Apartamento"
      when "B"  then "Box"
      when "C"  then "Casa"
      when "D"  then "Depósito"
      when "E"  then "Empresarial"
      when "F"  then "Flat"
      when "G"  then "Galpão"
      when "I"  then "Industrial"
      when "L"  then "Loja"
      when "O"  then "Outros"
      when "Q"  then "Quiosque"
      when "R"  then "Residencial"
      when "S"  then "Sala Comercial"
      when "SC" then "Loja em Shopping Center"
      else 
        "Não definido."
    end
  end


  private
    def enviar_email
    end

    def validar_cpf_cnpj
      if self.locatario_cpf_cnpj.present?
        if self.locatario_cpf_cnpj.size > 11
          if not valida_cnpj(self.locatario_cpf_cnpj) 
             errors.add(:locatario_cpf_cnpj, ' é inválido')
          end
        elsif not valida_cpf(self.locatario_cpf_cnpj) 
          errors.add(:locatario_cpf_cnpj, ' é inválido')
        end
      end
      if self.locador_cpf_cnpj.present?
        if self.locador_cpf_cnpj.size > 11
          if not valida_cnpj(self.locador_cpf_cnpj) 
             errors.add(:locador_cpf_cnpj, ' é inválido')
          end
        elsif not valida_cpf(self.locador_cpf_cnpj) 
          errors.add(:locador_cpf_cnpj, ' é inválido')
        end
      end
      if self.responsavel_legal_cpf.present?
        if not valida_cpf(self.responsavel_legal_cpf) 
          errors.add(:responsavel_legal_cpf, ' é inválido')
        end
      end
    end

    def validar_numero
      if self.numero.size != self.numero.to_s.gsub(/[^0-9]/, '').size
        self.errors.add(:numero, "aceita apenas números (0-9)")
        return false
      end
    end

    def validar_complemento
      if self.complemento.size != self.complemento.to_s.gsub(/[^0-9|A-Z|a-z|\s]/, '').size
        self.errors.add(:complemento, "aceita apenas números e letras (0-9, a-z, A-Z)")
        return false
      end
    end
end