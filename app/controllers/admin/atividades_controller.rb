class Admin::AtividadesController < AdminController
  #before_filter :login_required, only: [:index, :create, :update]
  before_filter :add_atividade,  only: [:create, :new]
  before_filter :edit_atividade, only: [:update, :edit]
  before_filter :set_atividade, only: [:show, :destroy, :edit, :update]

  skip_load_resource only: [:new, :create]

  def index
    if params[:atividade].present?
      atividade   = '%' + params[:atividade].upcase + '%'
      @atividades = Atividade.where(["upper(atividade) like ? or codigo like ?", atividade, atividade]).order(:atividade)
    else
      @atividades = Atividade.order(:atividade)
    end
  end

  # GET /atividades/1
  # GET /atividades/1.xml
  def show
  end

  # GET /atividades/new
  # GET /atividades/new.xml
  def new
    @atividade = Atividade.new
  end

  # GET /atividades/1/edit
  def edit
  end

  # POST /atividades
  # POST /atividades.xml
  def create
    @atividade = Atividade.new(atividade_params)
    if @atividade.save
      redirect_to edit_admin_atividade_path(@atividade), notice: t(:created, name: 'Atividade') 
    else
      render action: 'new' 
    end
  end

  # PUT /atividades/1
  # PUT /atividades/1.xml
  def update
    if @atividade.update(atividade_params)
      redirect_to edit_admin_atividade_path(@atividade), notice: t(:updated, name: 'Atividade') 
    else
      render action: 'edit' 
    end
  end

  ################################

  def add_atividade
    if !current_user.master and !current_user.add_atividade 
      flash[:error] = "Usuário sem permissão para cadastro de atividades"
      redirect_to request.env['HTTP_REFERER']
      return
    end
  end

  def busca_atividades
    @atividades =  Atividade.where(["UPPER(atividade) like ? and bloqueado is not true", '%' + params[:filtro].upcase + '%'])
    @atividades << Atividade.new(atividade: "Atividade não encontrada") if @atividades.blank?
    render layout: false
  end

  def edit_atividade
    if !current_user.master and !current_user.add_atividade 
      flash[:error] = "Usuário sem permissão para cadastro de atividades"
      redirect_to request.env['HTTP_REFERER']
      return
    end
  end

  def get_atividaes
    busca_atividades
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_atividade
      @atividade = Atividade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def atividade_params
      params.require(:atividade).permit(:codigo, :atividade, :observacao, :bloqueado)
    end
end