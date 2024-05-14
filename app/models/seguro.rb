class Seguro < ActiveRecord::Base
  require "#{Rails.root}/lib/valida_cpf_cnpj.rb"
  include ValidaCpfCnpj

  validates_presence_of :cep, :numero, :inquilino, :tipo_pessoa, :cpf_cnpj_inquilino, :user_id, message: ' é obrigatório'
  validates_presence_of :proprietario, :tipo_pessoa_proprietario, :cpf_cnpj_proprietario,       message: ' é obrigatório'
  validates_presence_of :limite_maximo_indenizacao, :status, :logradouro, :imobiliaria_id,      message: ' é obrigatório'
  #validates_numericality_of :limite_maximo_indenizacao,  message: ' não é válido.'
  validates_presence_of :complemento,             if: Proc.new { |s| s.residencia == 'A'     }, message: " é obrigatório para apartametos."
  validates_presence_of :cobertura_para_conteudo, if: Proc.new { |s| s.tipo_de_seguro == 'R' }, message: " é obrigatório para seguros residenciais."
  validates_presence_of :atividade_id,            if: Proc.new { |s| s.tipo_de_seguro == 'C' }, message: " é  obrigatória para seguros comerciais."
  validates_presence_of :residencia,              if: Proc.new { |s| s.tipo_de_seguro == 'R' }, message: " é obrigatória para seguros residenciais."

  validate :valida_cpf_cnpj
  validate :valida_valor

  belongs_to :transmitido_por, class_name: "User" 
  belongs_to :imobiliaria
  belongs_to :atividade
  belongs_to :arquivo
  belongs_to :user
  belongs_to :logradouro, foreign_key: :cep, primary_key: :cep
  #
  before_save :set_valor_premio
  before_save :set_atividade_id
 
  validate :validar_numero
  validate :validar_complemento
  attr_accessor :atividade_desc

  def initialize(attributes={})
    if attributes[:data_limite_renovacao].present?
      attributes.merge!(status: 3)
    else
      attributes.merge!(status: 0)
    end
    if attributes[:atividade_desc].present?
      attributes.merge!(atividade_id: Atividade.where(atividade: atividade_desc).first.try(:id))
    end
    super
  end

  def residencia_desc
    case self.residencia
      when 'A' then "Apartamento"
      else 
        "Casa"
    end
  end

  def gerar_renovacao(data =  nil)
    ren                = self.dup
    ren.status         = 3
    ren.marcado        = nil
    ren.arquivo_id     = nil
    ren.transmitido_em = nil
    ren.parent_id      = self.id
    ren.data_limite_renovacao = data || self.transmitido_em.beginning_of_month + 1.year
    ren.created_at     = ren.updated_at = Time.now
    ren.renovado       = false
    self.renovado      = true
    ren.save && self.save
  end

  def valida_valor
    if self.limite_maximo_indenizacao > 2000000.0
      errors.add(:limite_maximo_indenizacao, 'Limite da indenização não pode ser superior a R$ 2.000.000,00')
    end
    if self.limite_maximo_indenizacao < 30000.0 and self.tipo_de_seguro == 'R'
      errors.add(:limite_maximo_indenizacao, 'Limite da indenização não pode ser inferior a R$ 30.000,00')
    end
    if self.limite_maximo_indenizacao < 50000.0 and self.tipo_de_seguro == 'C'
      errors.add(:limite_maximo_indenizacao, 'Limite da indenização não pode ser inferior a R$ 50.000,00')
    end
  end

  def valida_cpf_cnpj
    self.inquilino = self.inquilino.upcase
    self.proprietario = self.proprietario.upcase
    if cpf_cnpj_proprietario.size > 11
      if not valida_cnpj(cpf_cnpj_proprietario) 
         errors.add(:cpf_cnpj_proprietario, 'CNPJ do proprietário é inválido')
      end
    elsif not valida_cpf(cpf_cnpj_proprietario) 
      errors.add(:cpf_cnpj_proprietario, 'CPF do proprietário é inválido')
    end

    if cpf_cnpj_inquilino.size > 11
      if not valida_cnpj(cpf_cnpj_inquilino) 
         errors.add(:cpf_cnpj_inquilino, 'CNPJ do inquilino é inválido')
      end
    elsif not valida_cpf(cpf_cnpj_inquilino) 
      errors.add(:cpf_cnpj_inquilino, 'CPF do inquilino é inválido')
    end

    if cpf_cnpj_proprietario.count(cpf_cnpj_proprietario.slice(0,1)) == cpf_cnpj_proprietario.size
      errors.add(:cpf_cnpj_proprietario, 'CPF do proprietário é inválido')
    end
    if cpf_cnpj_inquilino.count(cpf_cnpj_inquilino.slice(0,1)) == cpf_cnpj_inquilino.size
      errors.add(:cpf_cnpj_inquilino, 'CPF do inquilino é inválido')
    end
  end

  def valida_cobertura
    if self.tipo_de_seguro == 'R' and (self.cobertura_para_conteudo.blank? or self.cobertura_para_conteudo.nil?)
      self.errors.add(:cobertura_para_conteudo, "Cobertura para conteudo é obrigatório para seguros residenciais.")
      return false
    end
    return true
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

  def endereco_formatado
    retorno = ''
    if self.logradouro
      retorno = self.logradouro.endereco.to_s + ', ' + self.numero.to_s
      retorno << ' ' + self.complemento unless self.complemento.blank?
    end
    retorno
  end

  def descricao_cobertura
    case self.cobertura_para_conteudo
      when 10 then '10% com o Mínimo de R$ 5.000,00'
      when 20 then '20% com o Máximo de R$ 5.000,00'
      when 30 then '30%'
      else  
        ''
    end
  end 

  def valor_cobertura
    x = self.limite_maximo_indenizacao * self.cobertura_para_conteudo / 100
    if self.cobertura_para_conteudo >= 10 and self.cobertura_para_conteudo < 30 and x < 5000.0
      return 5000.0
    end
    return x
  end

  def baixar_arquivos!
    self.status = 2
    self.marcado = true
    self.save
  end

  def descricao_status
    case self.status 
      when 1 then "'Cobertura Enviada'"
      when 2 then "'Cobertura Enviada'"
      when 3 then "'Processo de Renovação'"
      else
        ''
    end
  end 

  def descricao_renovacao_sub
    if self.data_limite_renovacao
      if self.data_limite_renovacao < Date.today
        return "Vencido (#{self.data_limite_renovacao.to_s_br})"
      else
        return self.data_limite_renovacao.to_s_br
      end
    end
    return ''
  end

  def descricao_renovacao
    if self.data_limite_renovacao
      if [1].include?(self.status)
        return "Renovado"
      elsif self.data_limite_renovacao < Date.today
        return "Vencido (#{self.data_limite_renovacao.to_s_br})"
      else
        return self.data_limite_renovacao.to_s_br
      end
    end
    return ''
  end

  def risco_coberto
    data = self.transmitido_em.to_date + 1.month
    return Date.new(data.year, data.month, 10)
  end

  def tipo_de_seguro_desc
    case self.tipo_de_seguro
      when 'C' then "Empresarial:"
      when 'R' then "Residencial:"
      else 
        'Indefinido'
    end
   end
   
  def descricao_status_admin
    case self.status
      when 1 then 'Baixar Arquivo'
      when 2 then 'Arquivo Baixado'
      else
        'Indefinido'
    end
  end 

   def calculo_valor_premio
    cor = Corretora.last
    if self.tipo_de_seguro == 'R'
      return 0 if self.limite_maximo_indenizacao.to_f < 30000 or self.limite_maximo_indenizacao.to_f > 2000000
      #calcula o valor de cobertura para conteudo
      cc = (self.limite_maximo_indenizacao.to_f * self.cobertura_para_conteudo.to_f / 100)
      cc = 5000.to_f if cc < 5000 and self.cobertura_para_conteudo > 0
      # verifica a taxa imobiliaria
      taxa_imob = self.imobiliaria.taxa_residencial.to_f
      res = (self.limite_maximo_indenizacao.to_f + cc) * ((taxa_imob / 100) * (1 + (cor.iof.to_f / 100))).to_f
    else
      return 0 if self.limite_maximo_indenizacao.to_f < 50000 or self.limite_maximo_indenizacao.to_f > 2000000
      # verifica a taxa imobiliaria
      taxa_imob = self.imobiliaria.taxa_empresarial
      res = (self.limite_maximo_indenizacao)  * ((taxa_imob / 100) * (1 + (cor.iof / 100))).to_f
    end

    return  (res / 100.0).to_f.round(2)
  end
   
  def set_valor_premio
    self.premio_total = self.calculo_valor_premio.to_f
  end
   
  def self.gera_arquivo_remessa_residencial(arquivo)
    imobiliaria = arquivo.seguros[0].imobiliaria
    base_arquivo = imobiliaria.estipulante.split(' ')[0] + '_' + imobiliaria.estipulante.split(' ')[1] + '_R_' + Time.now.strftime("%H%M%S") + Date.today.to_s_br.gsub('/','') + '.km2'
    nome_arquivo = "#{Rails.public_path}/arquivos/residenciais/#{base_arquivo}"

    arq = File.open(nome_arquivo,"w")
    s = 1
    # aki entra o orcamento
    linha_cab = Seguro.gera_linha_orcamento('R', imobiliaria)
    arq.write(linha_cab)
    linha_cab = Seguro.gera_linha_corretor
    arq.write(linha_cab)
    linha = Seguro.gera_linha_cliente(imobiliaria)
    arq.write(linha)
    # fim cabeçalho
    #itens = Seguro.find_all_by_tipo_de_seguro 'R'
    itens = arquivo.seguros
    s = 0
    for item in itens
      s += 1
      linha = item.gera_linha_seguro(s)
      arq.write(linha)
      #uma linha para o predio e outra para o conteudo
      linha = item.gera_linha_cobertura(s,'11127')
      arq.write(linha)
      if  item.cobertura_para_conteudo != 0
        linha = item.gera_linha_cobertura(s,'11176')
        arq.write(linha)
      end 
    end
    linha_rodape = Seguro.gera_linha_rodape(imobiliaria)
    arq.write(linha_rodape)
    arq.close
    #usa o sed pra colocar as quebras de linha windows
    comando = "sed -i 's/$/\\r/' #{nome_arquivo}"    
    system(comando)
    comando = "iconv -f UTF-8 -t ISO8859-1 < #{nome_arquivo} > #{nome_arquivo}.2"
    system(comando)
    comando = "mv -f #{nome_arquivo}.2 #{nome_arquivo}"
    system(comando)
    #coloca o arquivo no registro
    arquivo.url = "/arquivos/residenciais/#{base_arquivo}"
    arquivo.save
  end

  def self.gera_arquivo_remessa_comercial(arquivo)
    imobiliaria = arquivo.seguros[0].imobiliaria
    base_arquivo = imobiliaria.estipulante.split(' ')[0] + '_' + imobiliaria.estipulante.split(' ')[1] + '_E_'+ Time.now.strftime("%H%M%S") + Date.today.to_s_br.gsub('/','') + '.km2'
    nome_arquivo = "#{Rails.public_path}/arquivos/comerciais/#{base_arquivo}"

    arq = File.open(nome_arquivo,"w")
    s = 1
    # aki entra o orcamento
    linha_cab = Seguro.gera_linha_orcamento('C', imobiliaria)
    arq.write(linha_cab)
    linha_cab = Seguro.gera_linha_corretor
    arq.write(linha_cab)
    linha = Seguro.gera_linha_cliente(imobiliaria)
    arq.write(linha)
    # fim cabeçalho
    #itens = Seguro.find_all_by_tipo_de_seguro 'C'
    itens = arquivo.seguros 
    s = 0
    for item in itens
      s += 1
      linha = item.gera_linha_seguro(s)
      arq.write(linha)
      #uma linha para o predio e outra para o conteudo
      linha = item.gera_linha_cobertura(s,'11101')
      arq.write(linha)
    end
    linha_rodape = Seguro.gera_linha_rodape(imobiliaria)
    arq.write(linha_rodape)
    arq.close
    #usa o sed pra colocar as quebras de linha windows
    comando = "sed -i 's/$/\\r/' #{nome_arquivo}"    
    system(comando)
    comando = "iconv -f UTF-8 -t ISO8859-1 < #{nome_arquivo} > #{nome_arquivo}.2"
    system(comando)
    comando = "mv -f #{nome_arquivo}.2 #{nome_arquivo}"
    system(comando)
    #comando = "mv -f #{nome_arquivo}.2 #{nome_arquivo}"
    #system(comando)
    #coloca o arquivo no registro
    arquivo.url = "/arquivos/comerciais/#{base_arquivo}"
    arquivo.save
  end


  def self.gera_linha_orcamento(tipo, imobiliaria)
    retorno = '00' # identificador
    if tipo == 'R' then
      retorno <<  '11401'
    else
      retorno << '11801'
    end # codigo do produto 11401 - residencial e 11801 - empresarial
    retorno << ''.rjust(6,'0') # numero do orcamento (preencher com zeros)
    retorno << Date.today.to_s_br # data que o arquivo foi gerado dd/mm/aaaa
    retorno << Date.today.beginning_of_month.to_s_br # Dia 01 do mes atual
    retorno << (Date.today + 1.year).beginning_of_month.to_s_br # Dia 01 do mesmo mes proximo ano 
    retorno << imobiliaria.estipulante.remover_acentos.ljust(60," ") #Razão Social da Imobiliária
    retorno << imobiliaria.tipo_pessoa #F – Física / J – Jurídica       
    retorno << imobiliaria.operacao.rjust(5,'0') #3 inteiros e 2 Decimais 5 106 109
    retorno << ''.rjust(5,'0') #Percentual Agravação	5	110	114	(3V2) 3 inteiros e 2 Decimais	ZEROS
    retorno << 'S'#Imprimir Certificado	1	115	115	S / N	Sempre S
    retorno << 'S' #Imprimir prêmio no Certificado	1	116	116	S / N	Sempre S
    retorno << 'N' #Tipo de Seguro	1	117	117		Sempre N
    #retorno << ''.rjust(10,' ')#Nº Apólice	10	118	127		ZEROS
    retorno << "\n" # quebra de linha
    retorno
  end
  
  def self.gera_linha_corretor
    c = Corretora.last
    retorno = '01' # identificador
    retorno << c.codigo_sucursal.rjust(2,'0') #código da Sucursal	2	3	4		
    retorno << c.codigo_corretor.rjust(5,'0') #Código do Corretor	5	5	9		
    retorno << ''.rjust(5,'0') #Código do Colaborador	5	10	14		ZEROS
    retorno << c.codigo_susep.rjust(14,'0') #Código SUSEP	14	15	28		
    retorno << c.tipo_de_pessoa #Tipo de Pessoa do Corretor	1	29	29	F – Física / J – Jurídica.
    retorno << c.razao_social.remover_acentos.slice(0,40).ljust(40,' ') #Nome / Razão Social do Corretor	40	30	69		
    retorno << c.codigo_da_inspetoria.rjust(6,'0') #Código da Inspetoria	6	70	75		
    retorno << c.codigo_do_inspetor.rjust(6,'0') #Código do Inspetor	6	76	81		
    retorno << c.email_corretor.ljust(60,' ') #E-Mail do Corretor	60	82	141		
    retorno << c.ddd_corretor #DDD Telefone Corretor	2	142	143		
    retorno << c.telefone_corretor #Telefone Corretor	8	144	151		
    retorno << c.ddd_corretor #DDD fax Corretor	2	142	143		
    retorno << c.telefone_corretor #fax Corretor	8	144	151
    retorno << 'N'
    retorno << "\n" # quebra de linha
    retorno
  end

  def self.gera_linha_cliente(imobiliaria)
    c = Corretora.last
    retorno = '02' #Identificador*	2	1	2	“02”
    retorno << ''.rjust(6,'0') #Código do Cliente*	6	3	8		ZEROS
    retorno << imobiliaria.cpf_cnpj.gsub('.','').gsub('/','').gsub('-','').rjust(14,'0') #CPF / CNPJ*	14	9	22

    #Data de Nascimento*	10 23	32	dd/mm/aaaa	
    if imobiliaria.tipo_pessoa == "F"
      if !imobiliaria.data_nascimento.blank?
        data = imobiliaria.data_nascimento.to_s_br
      else
        data = '          '
      end
      retorno << data
      retorno << '1' #???Tipo de Documento*	1	33	33	1 – RG /  2 – RNE / 3 – CLASSE	Encontra-se no cadastro da imobiliária.
      retorno << imobiliaria.ie_rg.rjust(15,'0') #RG*	15	34	48		
      retorno << imobiliaria.orgao_expeditor.ljust(20,' ') #Órgão Expeditor*	20	49	68
      if imobiliaria.data_expedicao 
        data = imobiliaria.data_expedicao.to_s_br
      else
        data = ''.ljust(10, ' ')
      end 
      retorno << data # Data Expedição*	 10	69	78	dd/mm/aaaa
    else 
      retorno << ''.ljust(56, ' ')
    end
    retorno << c.endereco.remover_acentos.slice(0,40).ljust(40,' ') #Endereço de Correspondência*	40	79	118		
    retorno << c.numero.rjust(6,'0') #Número do Endereço Correspondência*	6	119	124		
    retorno << c.complemento.remover_acentos.ljust(15,' ') #Compl. Do Endereço Correspondência	15	125	139		
    retorno << c.bairro.remover_acentos.slice(0,20).ljust(20,' ') #Bairro Correspondência*	20	140	159		
    retorno << c.cidade.remover_acentos.slice(0,40).ljust(40, ' ') #Cidade Correspondência*	40	160	199		
    retorno << c.uf.ljust(2,' ') #UF Correspondência*	2	200	201
    retorno << c.cep.ljust(8,' ') #Cep Correspondência*	8	202	209	
    retorno << c.ddd_corretor.ljust(2,' ') #DDD Tel Correspondência*	2	210	211		
    retorno << c.telefone_corretor.ljust(8,' ') #Tel Correspondência*	8	212	219		
    retorno << c.ddd_corretor.ljust(2,' ') #DDD fax Correspondência*	2	210	211		
    retorno << c.telefone_corretor.ljust(8,' ') #fax Correspondência*	8	212	219		
    retorno << c.endereco.remover_acentos.slice(0,40).ljust(40,' ') #Endereço de Cobranca*	40	79	118		
    retorno << c.numero.rjust(6,'0') #Número do Endereço cobranca*	6	119	124		
    retorno << c.complemento.remover_acentos.slice(0,15).ljust(15,' ') #Compl. Do Endereço cobranca	15	125	139		
    retorno << c.bairro.remover_acentos.slice(0,20).ljust(20,' ') #Bairro cobranca*	20	140	159		
    retorno << c.cidade.remover_acentos.slice(0,40).ljust(40, ' ') #Cidade cobranca*	40	160	199		
    retorno << c.uf.ljust(2,' ') #UF cobranca*	2	200	201
    retorno << c.cep.ljust(8,' ') #Cep cobranca*	8	202	209
    retorno << c.ddd_corretor.ljust(2,' ') #DDD Tel cobranca*	2	210	211		
    retorno << c.telefone_corretor.ljust(8,' ') #Tel cobranca*	8	212	219		
    retorno << c.ddd_corretor.ljust(2,' ') #DDD fax cobranca*	2	210	211		
    retorno << c.telefone_corretor.ljust(8,' ') #fax cobranca*	8	212	219		
    retorno << imobiliaria.estipulante.remover_acentos.slice(0,40).ljust(40,' ') #Nome Cliente*	40	381	420		
    retorno << imobiliaria.tipo_pessoa #Tipo de Pessoa do Cliente	1	421	421		
    retorno << "\n" # quebra de linha
    retorno
  end

  def gera_linha_seguro(s)
    retorno = '03' 						#Identificador			2	1	2	“03”
    retorno << s.to_s.rjust(6,'0') 				#Número do Item			6	3	8     Sequencial de acordo com o número de itens solicitados para geração daquele arquivo. 
    retorno << self.inquilino.remover_acentos.ljust(60,' ') 			#Nome do Inquilino		60	9	68		
    retorno << self.tipo_pessoa[1,1] 				#Tipo de Pessoa do Inquilino	1	69	69	F – Física / J – Jurídica.
    retorno << self.cpf_cnpj_inquilino.rjust(14,'0') 		#CPF / CNPJ Inquilino		14	70	83
    retorno << self.proprietario.remover_acentos.ljust(60,' ') 		#Nome do Proprietário		60	84	143
    retorno << self.tipo_pessoa_proprietario[1,1] 		#Tipo de Pessoa do Proprietário	1	144	144	F – Física / J – Jurídica.	Cadastro do item.
    retorno << self.cpf_cnpj_proprietario.rjust(14,'0') 	#CPF / CNPJ Proprietário	14	145	158
    retorno << self.logradouro.endereco.remover_acentos.slice(0,40).ljust(40) 		#Endereco			40	159	198
    retorno << self.numero.rjust(6,'0') 			#Numero do Endereço		6	199	204		
    retorno << self.complemento.remover_acentos.slice(0,15).ljust(15,' ') 			#Compl. Do Endereço		15	205	219
    retorno << self.logradouro.nome_bairro.remover_acentos.slice(0,30).ljust(30, ' ') 	#Bairro				30	220	249		
    retorno << self.logradouro.localidade.nome.remover_acentos.slice(0,30).ljust(30, ' ') 	#Cidade				30	250	279	
    retorno << self.logradouro.uf 				#UF				2	280	281

    #corrigir ids
    #<Localidade id: 12272, codigo_correios: 1347, uf: "CE", nome: "Fortaleza", tipo: "M", codigo_ibge: "2304400">
    if [1347].include?(self.logradouro.codigo_cidade) and ['CENTRO', 'JOSÉ BONIFÁCIO', 'FARIAS BRITO', 'PRAIA DE IRACEMA'].include?(self.logradouro.nome_bairro.upcase)
      retorno << '60000000'
    else
      retorno << self.cep 					#CEP				8	282	289
    end

    if self.tipo_de_seguro == 'C' then
      retorno << self.atividade.codigo.rjust(4,'0') 		#Código da Atividade		4	290	293	"EMPRESARIAL:
    else
      if self.residencia  == 'A' then
        retorno << '0919'
      else
        retorno << '0911'
      end
    end
    if (self.tipo_de_seguro == 'C') or (self.tipo_de_seguro == 'R' and self.cobertura_para_conteudo == 0) then
      retorno << '1'
    else
      retorno << '2'
    end #Cobertura	1	294	294	Se RESIDENCIAL: 2  Se EMPRESARIAL: 1
    if self.tipo_de_seguro == 'C' then
      retorno << '0'
    elsif self.residencia == 'A'
      retorno <<  '2'
    else
      retorno << '1'	
    end               #Tipo de Residencia	1	295	295	1 – Casa / 2 – Apartamento	Se Empresarial = 0
    retorno << '1101' #Tipo de Moradia	        4	296	299	Sempre 1101	
    retorno << '2'    #Tipo de Construção	1	300	300	Sempre 2	
    retorno << '0'    #Indicador de Assitência	1	301	301	Sempre 0	
    retorno << '0'.rjust(6,'0') #Número do Orçamento	6	302	307		ZEROS
    retorno << ''.ljust(10,' ') #Data de Nascimento Inquilino	10	308	317	dd/mm/aaaa	Sempre em branco
   
    retorno << "Complemento endereco " # Fixo 21 318 338
    retorno << self.complemento.remover_acentos.slice(0,50).ljust(50,' ') #Observação	50	339	388		
    retorno << ''.ljust(183,' ') #Observação	183	389	571		

    if self.tipo_de_seguro == 'R' and self.cobertura_para_conteudo != 0
      retorno << '100'
    else
      retorno << '000'
    end 
    retorno << "000000"   #0 Fixo de 575 ~ 580
    retorno << "\n" # quebra de linha
    retorno
  end


  def gera_linha_cobertura(s,codigo_cobertura)
    retorno = '05' #Identificador	2	1	2	“05”
    retorno << s.to_s.rjust(6,'0') #Número do Item	6	3	8		Sequencial de acordo com o número de itens solicitados para geração daquele arquivo.
    retorno << '0'.rjust(6,'0') #Número do Orçamento	6	9	14		ZEROS
    if codigo_cobertura == '11101' then # empresarial 
      retorno << '011101'
      retorno << (self.limite_maximo_indenizacao * 100).to_i.to_s.rjust(17,'0')
      retorno << (self.imobiliaria.taxa_empresarial * 100).to_i.to_s.rjust(6,'0')
    elsif codigo_cobertura == '11127' # cobertura residencia predio
      if self.tipo_de_seguro == 'R' and self.cobertura_para_conteudo == 0
        retorno << '011101'
      else
        retorno << '011127'
      end
      retorno << (self.limite_maximo_indenizacao * 100).to_i.to_s.rjust(17,'0')
      retorno << (self.imobiliaria.taxa_residencial * 100).to_i.to_s.rjust(6,'0')
    elsif codigo_cobertura == '11176' # cobertura residencia conteudo
      retorno << '011176'
      #verificar se o conteudo vai ser minimo ou o percentual
      valor = 0
      valor = (self.limite_maximo_indenizacao * self.cobertura_para_conteudo / 100)
      valor = 5000 if valor < 5000
      retorno << (valor * 100).to_i.to_s.rjust(17,'0')
      retorno << (self.imobiliaria.taxa_residencial * 100).to_i.to_s.rjust(6,'0')
    end
    retorno << '1'
    retorno << "\n" # quebra de linha
    retorno
  end 

  def self.gera_linha_rodape(imobiliaria)
    c = Corretora.last
    retorno = '09' # identificador
    retorno << 'T' # Situacao      Fixo     1 3 3 
    retorno << c.codigo_sucursal.rjust(2,'0') #código da Sucursal 2 4 5   
    retorno << c.codigo_corretor.rjust(6,'0') #Código do Corretor 6 6 11   
    retorno << ''.rjust(6,'0') #Código do Colaborador 6 12  17    ZEROS
    retorno << c.razao_social.remover_acentos.slice(0,60).ljust(60,' ') #Nome / Razão Social do Corretor  60  18  77    
    retorno << imobiliaria.operacao.rjust(5,'0') #3 inteiros e 2 Decimais 5 78 82
    retorno << "\n" # quebra de linha
    retorno
  end

  def set_atividade_id
    if self.atividade_desc
      self.atividade_id = Atividade.where(atividade: self.atividade_desc).first.try(:id)
    end
  end
end
