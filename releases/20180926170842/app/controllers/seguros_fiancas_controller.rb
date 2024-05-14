class SegurosFiancasController < ApplicationController
  before_action :set_seguro_fianca, only: [:show, :edit, :update, :destroy]

  # GET /seguros_fiancas
  # GET /seguros_fiancas.json
  def index
    cond = ["seguros_fiancas.created_at::date > ?", Date.today - 60.days]
    join = [""]
    if params[:busca].present?
      join = "left join locatarios loc on loc.seguro_fianca_id = seguros_fiancas.id join logradouros l on l.cep = seguros_fiancas.cep"
      cond[0] += " and " unless cond[0].blank?
      cond[0] += " (upper(loc.nome) like upper(?) or upper(l.tipo || ' ' || l.nome) like upper(?))"
      cond    << '%' + params[:busca] + '%'
      cond    << '%' + params[:busca] + '%'
    end
    if current_user.tipo == 'I' or ( current_user.is?(:administrador) and current_user.imobiliaria_id )
      cond[0] += " and " unless cond[0].blank?
      cond[0] += "imobiliaria_id = #{current_user.imobiliaria_id}"
    end
    @seguros_fiancas = SeguroFianca.where(cond).joins(join).includes(:logradouro, :locatarios).order("created_at desc")
  end

  # GET /seguros_fiancas/1
  # GET /seguros_fiancas/1.json
  def show
    @locatarios = @seguro_fianca.locatarios.order(:id)
  end

  # GET /seguros_fiancas/new
  def new
    @seguro_fianca = SeguroFianca.new
  end

  # GET /seguros_fiancas/1/edit
  def edit
  end

  # POST /seguros_fiancas
  # POST /seguros_fiancas.json
  def create
    @seguro_fianca = SeguroFianca.new(seguro_fianca_params.merge(user_id: current_user.id, imobiliaria_id: current_user.imobiliaria_id, status: 0))
    if @seguro_fianca.save
      if Rails.env.production?
        Emailer.novo_seguro_fianca(@seguro_fianca.id, 'paulohenrique@webtecmaster.com.br').deliver_now
        Emailer.novo_seguro_fianca(@seguro_fianca.id, 'comercial@webtecmaster.com.br').deliver_now
        Emailer.novo_seguro_fianca(@seguro_fianca.id, 'apoio@webtecmaster.com.br').deliver_now
      end
      redirect_to seguros_fiancas_path, notice: 'Seguro Fiança cadastrado com sucesso.' 
    else
      render :new
    end
  end

  # PATCH/PUT /seguros_fiancas/1
  # PATCH/PUT /seguros_fiancas/1.json
  def update
    if @seguro_fianca.update(seguro_fianca_params)
      if Rails.env.production?
        Emailer.novo_seguro_fianca(@seguro_fianca.id, 'paulohenrique@webtecmaster.com.br').deliver_now
        Emailer.novo_seguro_fianca(@seguro_fianca.id, 'comercial@webtecmaster.com.br').deliver_now
        Emailer.novo_seguro_fianca(@seguro_fianca.id, 'apoio@webtecmaster.com.br').deliver_now
      end
      redirect_to edit_seguro_fianca_path(@seguro_fianca), notice: 'Seguro Fiança atualizado com sucesso.'
    else
      render :edit 
    end
  end

  # DELETE /seguros_fiancas/1
  # DELETE /seguros_fiancas/1.json
  def destroy
    @seguro_fianca.destroy
    redirect_to seguros_fiancas_url, notice: 'Seguro fianca was successfully destroyed.' 
  end

  def load_locatarios
    @finalidade = params[:finalidade].try(:to_i)
    @locatarios = params[:num_locatarios].try(:to_i) if @finalidade == 1 # Residencial - PF
    render layout: false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seguro_fianca
      @seguro_fianca = SeguroFianca.find(params[:id])
    end

    def tratar_dados
      if params[:seguro_fianca].present? 
        params[:seguro_fianca][:cep] = params[:seguro_fianca][:cep].gsub(/\D/, "")                                         if params[:seguro_fianca][:cep].present?
        params[:seguro_fianca][:valor_condominio] = params[:seguro_fianca][:valor_condominio].gsub(".", "").gsub(",", ".") if params[:seguro_fianca][:valor_condominio].present? 
        params[:seguro_fianca][:valor_iptu]       = params[:seguro_fianca][:valor_iptu].gsub(".", "").gsub(",", ".")             if params[:seguro_fianca][:valor_iptu].present? 
        params[:seguro_fianca][:valor_locacao]    = params[:seguro_fianca][:valor_locacao].gsub(".", "").gsub(",", ".")       if params[:seguro_fianca][:valor_locacao].present?
        params[:seguro_fianca][:valor_aluguel]    = params[:seguro_fianca][:valor_aluguel].gsub(".", "").gsub(",", ".")       if params[:seguro_fianca][:valor_aluguel].present?
        if params[:seguro_fianca][:locatarios_attributes].present?
          if params[:seguro_fianca][:locatarios_attributes]["0"].present?
            if params[:seguro_fianca][:locatarios_attributes]["0"][:cpf_cnpj].present?
              params[:seguro_fianca][:locatarios_attributes]["0"][:cpf_cnpj] = params[:seguro_fianca][:locatarios_attributes]["0"][:cpf_cnpj].gsub(/\D/, "")
            end
            if params[:seguro_fianca][:locatarios_attributes]["0"][:renda].present?
              params[:seguro_fianca][:locatarios_attributes]["0"][:renda] = params[:seguro_fianca][:locatarios_attributes]["0"][:renda].gsub(".", "").gsub(",", ".")       
            end
          end
          if params[:seguro_fianca][:locatarios_attributes]["1"].present?
            if params[:seguro_fianca][:locatarios_attributes]["1"][:cpf_cnpj].present?
              params[:seguro_fianca][:locatarios_attributes]["1"][:cpf_cnpj] = params[:seguro_fianca][:locatarios_attributes]["1"][:cpf_cnpj].gsub(/\D/, "")  
            end
            if params[:seguro_fianca][:locatarios_attributes]["1"][:renda].present?
              params[:seguro_fianca][:locatarios_attributes]["1"][:renda] = params[:seguro_fianca][:locatarios_attributes]["1"][:renda].gsub(".", "").gsub(",", ".")       
            end
          end
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def seguro_fianca_params
      tratar_dados
      locatario_params = [:id, :nome, :cpf_cnpj, :estado_civil, :residira_no_imovel, :renda, :vinculo_empregaticio ]
      params.require(:seguro_fianca).permit(:finalidade, :cep, :numero, :complemento, :tipo_do_imovel, :valor_aluguel, :valor_condominio, :valor_iptu, :danos_ao_imovel, :multa_recisoria, :pintura_interna, :pintura_externa, :user_id, :imobiliaria_id, :status, locatarios_attributes: locatario_params )
    end
end