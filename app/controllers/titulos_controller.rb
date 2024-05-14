class TitulosController < ApplicationController

  before_filter :set_titulo, only: [:show, :edit, :update, :destroy]

  # GET /titulos
  # GET /titulos.xml
  def index
    cond = ["created_at::date > ?", Date.today - 60.days]
    join = [""]
    if params[:busca].present?
      cond[0] += " and " unless cond[0].blank?
      cond[0] += " (upper(locatario_nome) like upper(?) or upper(l.tipo || ' ' ||l.nome) like upper(?))"
      cond    << '%' + params[:busca] + '%'
      cond    << '%' + params[:busca] + '%'
      join = "join logradouros l on l.cep = titulos.cep"
    end
    if current_user.tipo == 'I' or ( current_user.is?(:administrador) and current_user.imobiliaria_id )
      cond[0] += " and " unless cond[0].blank?
      cond[0] += "imobiliaria_id = #{current_user.imobiliaria_id}"
    end
    @titulos  = Titulo.where(cond).joins(join).includes(:logradouro).order("created_at desc") #.paginate(:page => params[:page])
  end

  def show
  end

  # GET /titulos/new
  # GET /titulos/new.xml
  def new
    @titulo     = Titulo.new(cep: params[:cep])
  end

  # GET /titulos/1/edit
  def edit
  end

  # POST /titulos
  # POST /titulos.xml
  def create
    @titulo = Titulo.new(titulo_params.merge(user_id: current_user.id, imobiliaria_id: current_user.imobiliaria_id))
    if @titulo.save
      if Rails.env.production?
        Emailer.novo_titulo(@titulo.id, 'paulohenrique@webtecmaster.com.br').deliver_now
        Emailer.novo_titulo(@titulo.id, 'comercial@webtecmaster.com.br').deliver_now
        Emailer.novo_titulo(@titulo.id, 'apoio@webtecmaster.com.br').deliver_now
      end
      redirect_to(titulos_path, notice: 'Título cadastrado com sucesso.') 
    else
      render :action => "new" 
    end
  end

  # PUT /titulos/1
  # PUT /titulos/1.xml
  def update
    if @titulo.update(titulo_params.merge(user_id: current_user.id, imobiliaria_id: current_user.imobiliaria_id))
      redirect_to titulos_path, notice: 'Título atualizado com sucesso.'
    else
      render :action => "edit" 
    end
  end

  # DELETE /titulos/1
  # DELETE /titulos/1.xml
  def destroy
    if @titulo.destroy
      redirect_to titulos_path, notice: "Título removido com sucesso"
    end
  end

  private
    def set_titulo
      @titulo = Titulo.find(params[:id])
    end

    def tratar_dados
      if params[:titulo].present? 
        if params[:titulo][:cep].present?
          params[:titulo][:cep] = params[:titulo][:cep].gsub(/\D/, "")                         
        end
        if params[:titulo][:locador_cpf_cnpj].present?
          params[:titulo][:locador_cpf_cnpj] = params[:titulo][:locador_cpf_cnpj].gsub(/\D/, "")            
        end
        if params[:titulo][:valor_titulo].present?
          params[:titulo][:valor_titulo] = params[:titulo][:valor_titulo].gsub(".", "").gsub(",", ".")  
        end
        if params[:titulo][:valor_locacao].present?
          params[:titulo][:valor_locacao] = params[:titulo][:valor_locacao].gsub(".", "").gsub(",", ".") 
        end
        if params[:titulo][:locatario_cpf_cnpj].present?
          params[:titulo][:locatario_cpf_cnpj]    = params[:titulo][:locatario_cpf_cnpj].gsub(/\D/, "")          
        end
        if params[:titulo][:responsavel_legal_cpf].present?
          params[:titulo][:responsavel_legal_cpf] = params[:titulo][:responsavel_legal_cpf].gsub(/\D/, "")          
        end
      end
    end

    def titulo_params
      tratar_dados
      params.require(:titulo).permit( :finalidade_do_imovel, :tipo_do_imovel, :valor_locacao, 
                                      :locatario_nome, :locatario_tipo, :locatario_cpf_cnpj, :locatario_telefone, :locatario_email, 
                                      :locatario_data_nascimento, :locatario_rg, :locatario_orgao_emissor, :locatario_profissao, 
                                      :locatario_data_expedicao, :finalidade_do_imovel, :multiplicador_do_titulo, 
                                      :responsavel_legal_nome, :responsavel_legal_rg,  :locatario_atividade, :responsavel_legal_cpf, 
                                      :cep, :logradouro, :numero, :complemento, :locatario_nome, :logradouro, :valor_titulo,
                                      :locador_nome, :locador_tipo, :locador_cpf_cnpj, :valor_titulo, :meses_do_titulo)
    end
end
