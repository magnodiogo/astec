class Admin::ImobiliariasController < AdminController
  #before_filter :load_tipo_pessoa
  #before_filter :corrigir_params, only: [:create, :update]
  #before_filter :admin_required
  #before_filter :bloqueia_imobiliaria?, only: :destroy
  #before_filter :edit_imobiliaria?,     only: [:edit, :update]

  before_action :set_imobiliaria,       only: [:show, :destroy, :edit, :update, :block_unblock, :usuarios]
  skip_load_resource only: [:new, :create]

  def index
    @imobiliarias = Imobiliaria.order(:bloqueada, :nome_fantasia).includes(:seguros, :documentos)
  end

  # GET /imobiliarias/1
  # GET /imobiliarias/1.xml
  def show
  end

  # GET /imobiliarias/new
  # GET /imobiliarias/new.xml
  def new
    @imobiliaria = Imobiliaria.new
  end

  # GET /imobiliarias/1/edit
  def edit
  end

  # POST /imobiliarias
  # POST /imobiliarias.xml
  def create
    @imobiliaria = Imobiliaria.new(imobiliaria_params)
    if @imobiliaria.save
      redirect_to admin_imobiliarias_path, notice: t(:created, name: 'Imobiliária') 
    else
      render action: 'new' 
    end
  end

  # PUT /imobiliarias/1
  # PUT /imobiliarias/1.xml
  def update
    if @imobiliaria.update(imobiliaria_params)
      redirect_to edit_admin_imobiliaria_path(@imobiliaria), notice: t(:updated, name: 'Imobiliária') 
    else
      render action: 'edit' 
    end
  end

  # DELETE /imobiliarias/1
  # DELETE /imobiliarias/1.xml
  def destroy
    if @imobiliaria and @imobiliaria.documentos.blank? and @imobiliaria.seguros.blank? and current_user.master
      @imobiliaria.users.destroy_all     
      @imobiliaria.destroy
      redirect_to :back, notice: "Imobiliária excluída com sucesso."
    else
      redirect_to :back, flash: { error: "Não foi possível apagar a Imobiliária selecionada." }
    end
  end

################################

  def block_unblock 
    if @imobiliaria.bloqueia!
      redirect_to :back, notice: "Imobiliária #{@imobiliaria.bloqueada ? 'bloqueada' : 'desbloqueada'} com sucesso" 
    end
  end


  def documentos
    if params[:id].blank?
      flash[:error] = "Falha ao acessar a página."
      redirect_to action: :index
      return
    end
    @imobiliaria = Imobiliaria.find(params[:id])
    @documentos  = @imobiliaria.documentos.order('id asc')
    @documento = Documento.new
  end 

  def usuarios
    @users = @imobiliaria.users.order("name asc")
    #render template: "users/index"
  end

  def load_tipo_pessoa
    @tipo_pessoa = [['Pessoa Física','F'],['Pessoa Jurídica','J']]
  end

  def corrigir_params
    if params[:imobiliaria].present? 
      if params[:imobiliaria][:data_nascimento].present?
      params[:imobiliaria][:data_nascimento] = params[:imobiliaria][:data_nascimento].to_date
      end 
      if params[:imobiliaria][:data_expedicao].present?
      params[:imobiliaria][:data_expedicao] = params[:imobiliaria][:data_expedicao].to_date
      end 
      if params[:imobiliaria][:taxa_residencial].present?
      params[:imobiliaria][:taxa_residencial] = params[:imobiliaria][:taxa_residencial].gsub(',','.')
      end 
      if params[:imobiliaria][:taxa_empresarial].present?
      params[:imobiliaria][:taxa_empresarial] = params[:imobiliaria][:taxa_empresarial].gsub(',','.')
      end 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_imobiliaria
      @imobiliaria = Imobiliaria.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def imobiliaria_params
      params.require(:imobiliaria).permit(:nome_fantasia, :estipulante, :tipo_pessoa, :cpf_cnpj, :data_nascimento, :ie_rg, 
                                          :data_expedicao, :orgao_expeditor, :endereco, :numero, :complemento, :bairro,
                                          :cidade, :estado, :telefone, :celular, :contato, :email, :retorno, :operacao, 
                                          :taxa_residencial, :taxa_empresarial, :valor_no_recibo, :pro_laborista, :bloqueada)
    end
end