class SegurosController < ApplicationController
  before_action :authenticate_user!, except: :calcula_premio
  before_action :set_seguro,     only: [:transmitir, :desfazer_transmitir, :edit, :update, :destroy]
  before_action :load_cobertura, only: [:new, :edit, :update, :create, :calculadora]
  load_and_authorize_resource
  skip_load_resource only: [:new, :create]

  def index
    if params[:tipo] == 'R'
      @type   = { id: params[:tipo], singular: "Residencial", plural: "Residenciais" }
    else
      @type   = { id: params[:tipo], singular: "Empresarial", plural: "Empresariais" }
    end
    cond    = [""]
    join    =  ""
    if params[:mes].present?
      @mes = params[:mes]
      mes  = case @mes.split(' ')[0]
                  when 'Janeiro'   then 1
                  when 'Fevereiro' then 2
                  when 'Março'     then 3
                  when 'Abril'     then 4
                  when 'Maio'      then 5
                  when 'Junho'     then 6
                  when 'Julho'     then 7
                  when 'Agosto'    then 8
                  when 'Setembro'  then 9
                  when 'Outubro'   then 10
                  when 'Novembro'  then 11
                  when 'Dezembro'  then 12
                  else
                    nil
              end
       ano  = @mes.split(' ')[2].to_i
       if mes and ano
        @inicio = Date.new(ano, mes, 1)
        # no mes corrente pega todos os em aberto
        if mes == Date.today.month and ano == Date.today.year
          cond[0]= "((seguros.transmitido_em::date between ? and ? and status in (1,2)) or status in (0,3))"
          cond  << @inicio
          cond  << @inicio.end_of_month
        else
          cond[0]= "seguros.transmitido_em::date between ? and ? and status in (1,2)"
          cond  << @inicio
          cond  << @inicio.end_of_month
        end
      end
    end
    if params[:busca].present?
      cond[0] += " and "       unless cond[0].blank?
      cond[0] += " (upper(inquilino) like upper(?) or upper(l.tipo || ' ' ||l.nome) like upper(?))"
      cond    << '%' + params[:busca] + '%'
      cond    << '%' + params[:busca] + '%'
      join = "join logradouros l on l.cep = seguros.cep"
    end
    if params[:tipo].present?
      cond[0] += " and "       unless cond[0].blank?
      @tipo    = params['tipo']
      cond[0] += "tipo_de_seguro = ?"
      cond    << params[:tipo]
    end
    if current_user.tipo == 'I' or (current_user.tipo == 'A' and current_user.imobiliaria_id )
      cond[0] += " and " unless cond[0].blank?
      cond[0] += " imobiliaria_id = #{current_user.imobiliaria_id} "
    end
    @seguros  = Seguro.where(cond).joins(join).includes(:imobiliaria, :logradouro).
                        order("transmitido_em desc, created_at desc").paginate(per_page: 20, page: params[:page])
  end

  def show
    @seguro = Seguro.find(params[:id])
    @cep    = Logradouro.find_by_cep @seguro.cep
    @seguro.limite_maximo_indenizacao = @seguro.limite_maximo_indenizacao.to_s.gsub('.',',')

    if @seguro.atividade
       @atividades = []
       @atividades << [@seguro.atividade.atividade, @seguro.atividade.id] 
    else
       @cobertura = []
       @cobertura << [@seguro.descricao_cobertura, @seguro.cobertura_para_conteudo]
    end
    if @seguro.status == 3 and @seguro.imobiliaria_id == current_user.imobiliaria_id and current_user.tipo != 'A'
       @seguro.status = 0
       @seguro.save
    end
  end
  
  def new
    @seguro = Seguro.new(cep: params[:cep])
    @tipo   = params['tipo'].present? ? params[:tipo] : 'C'
  end

  # GET /seguros/1/edit
  def edit
    @tipo   = @seguro.tipo_de_seguro
    if @seguro.status == 3 and @seguro.imobiliaria_id == current_user.imobiliaria_id and current_user.tipo != 'A'
      @seguro.status = 0
      @seguro.save
    end
  end
  
  # POST /seguros
  # POST /seguros.xml
  def create
    @seguro = Seguro.new(seguro_params.merge(imobiliaria_id: current_user.imobiliaria_id, user_id: current_user.id))
    @seguro.atividade_id = Atividade.where(atividade: @seguro.atividade_desc).first.try(:id)
    @cep    = @seguro.logradouro || Logradouro.new 
    @tipo   = (params[:seguro].present? and params[:seguro][:residencia].present? ? 'R' : 'C')
    if @seguro.valid? and @seguro.save
      redirect_to seguros_path(mes: params[:mes], tipo: @tipo), notice: 'Seguro cadastrado com sucesso.'
    else
      @seguro.premio_total = @seguro.calculo_valor_premio.to_f.real
      render :action => "new" 
    end
  end

  # PUT /seguros/1
  # PUT /seguros/1.xml
  def update
    @cep    = @seguro.logradouro || Logradouro.new 
    @tipo   = params['tipo'].present? ? params[:tipo] : 'C'
    if @seguro.transmitido_em.nil?
      status  = (params[:renovacao].present? ? 3 : 0)   
    else
      status  = @seguro.status
    end
    if @seguro.update(seguro_params.merge(imobiliaria_id: current_user.imobiliaria_id, transmitido_em: (@seguro.transmitido_em || Time.now), status: status))
      redirect_to seguros_path(mes: params[:mes], tipo: @tipo), :notice => 'Seguro atualizado com sucesso.'
    else
      render :action => "edit" 
    end
  end

  # DELETE /seguros/1
  # DELETE /seguros/1.xml
  def destroy
    @seguro.destroy
    redirect_to :back, :notice => 'Seguro removido com sucesso'
  end

  def residencial
    if current_user.administrador?
      sql = "select * from fnc_resumo_seguros_imob_completo('R', #{current_user.imobiliaria_id})"
    else
      sql = "select * from fnc_resumo_seguros_imob('R', #{current_user.imobiliaria_id})"
    end
    @resultados = ActiveRecord::Base.connection.execute(sql).to_a
  end

  def empresarial
    if current_user.administrador?
      sql = "select * from fnc_resumo_seguros_imob_completo('C', #{current_user.imobiliaria_id})"
    else
      sql = "select * from fnc_resumo_seguros_imob('C', #{current_user.imobiliaria_id})"
    end
    @resultados = ActiveRecord::Base.connection.execute(sql).to_a
  end

  def transmitir
    if @seguro.update(status: 1, transmitido_em: Time.now, transmitido_por: current_user)
      redirect_to :back, notice: "Seguro transmitido com sucesso." 
    else
      redirect_to :back, notice: "Falha ao tentar transmitir, entre em contato com o administrador." 
    end
  end

  def desfazer_transmitir
    @seguro.assign_attributes(status: 0, transmitido_em: nil, transmitido_por: nil)
    if @seguro.save(validate: false)
      redirect_to :back, notice: "Transmissão removida." 
    else
      redirect_to :back, notice: "Falha ao remover transmissão, entre em contato com o administrador. [#{@seguro.errors.full_messags}]." 
    end
  end

  def gerar_pdf
    render pdf: "seguro_1#{@seguro.id.to_s.rjust(7,'0')}"
  end

  def inicio
  end

  def calculadora
    @seguro = Seguro.new
  end

  def calcula_premio
    @premio = 0
    if params[:seguro_limite_maximo_indenizacao].present? 
      #and params[:seguro_cobertura_para_conteudo].present?
      begin
        s = Seguro.new(:limite_maximo_indenizacao => params[:seguro_limite_maximo_indenizacao].gsub('.','').gsub(',','.').to_f, 
                       :cobertura_para_conteudo   => params[:seguro_cobertura_para_conteudo], 
                       :tipo_de_seguro            => params[:seguro_tipo_de_seguro], 
                       :imobiliaria_id            => params[:imobiliaria_id])
        @premio = s.calculo_valor_premio.to_f.real
      rescue
      end
    end
    @seguros = s
    render text: @premio
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seguro
      @seguro = Seguro.find(params[:id])
    end

    def tratar_campos
      if params[:seguro].present? and params[:seguro][:limite_maximo_indenizacao].present?
        params[:seguro][:limite_maximo_indenizacao] = params[:seguro][:limite_maximo_indenizacao].gsub('.','').gsub(',','.').to_f
      end
      if params[:seguro].present? and params[:seguro][:cep].present?
        params[:seguro][:cep] = params[:seguro][:cep].gsub(/[^0-9]/, '')
      end
      if params[:seguro].present? and params[:seguro][:cpf_cnpj_proprietario].present?
        params[:seguro][:cpf_cnpj_proprietario] = params[:seguro][:cpf_cnpj_proprietario].gsub(/[^0-9]/, '')
      end
      if params[:seguro].present? and params[:seguro][:cpf_cnpj_inquilino].present?
        params[:seguro][:cpf_cnpj_inquilino] = params[:seguro][:cpf_cnpj_inquilino].gsub(/[^0-9]/, '')
      end
    end

    def seguro_params
      tratar_campos
      params.require(:seguro).permit( :cep, :numero, :complemento, :tipo_de_seguro,
                                      :inquilino, :tipo_pessoa, :cpf_cnpj_inquilino,
                                      :proprietario, :tipo_pessoa_proprietario, :cpf_cnpj_proprietario,
                                      :limite_maximo_indenizacao, :cobertura_para_conteudo, :atividade_desc,
                                      :residencia, :data_limite_renovacao)
    end

    def load_cobertura
      @cobertura = [['Sem cobertura para conteúdo', 0],['10% com o mínimo de R$ 5.000,00', 10], ['20%', 20],['30%', 30]]
    end

=begin
    def load_tipo_pessoa
      @tipo_pessoa = [['Pessoa Física', 'PF'], ['Pessoa Jurídica', 'PJ']]
    end

    def load_atividades
      @atividades = [['Selecione', nil]]
    end
=end
end

