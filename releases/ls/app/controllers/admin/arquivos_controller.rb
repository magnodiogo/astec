class Admin::ArquivosController < AdminController
  before_action :set_arquivo, only: [:show, :edit, :update]
  skip_load_resource only: [:new, :create]

  # GET /arquivos
  # GET /arquivos.xml
  def index
    @arquivos = Arquivo.order(id: :desc).paginate(page: params[:page], per_page: 30)
  end

  # GET /arquivos/1
  # GET /arquivos/1.xml
  def show
  end

  # GET /arquivos/new
  # GET /arquivos/new.xml
  def new
    @arquivo  = Arquivo.new(params[:arquivo].present? ? arquivo_params : nil)
    @seguros = []
    if @arquivo.tipo and @arquivo.imobiliaria_id
      @seguros = Seguro.where(tipo_de_seguro: @arquivo.tipo, imobiliaria_id: @arquivo.imobiliaria_id, status: [1,2]).order(transmitido_em: :desc).paginate(page: params[:page], per_page: 20)
    elsif @arquivo.tipo or @arquivo.imobiliaria_id
      flash[:error] = "Campo Imobiliária e Tipo são obrigatóriios."
    end
  end

  # GET /arquivos/1/edit
  def edit
  end

  # POST /arquivos
  # POST /arquivos.xml
  def create
    @arquivo = Arquivo.new(arquivo_params)
    @arquivo.save
    @seguros = Seguro.where(id: params[:marcado]).includes(:logradouro, :imobiliaria)
    if @seguros.any?
      @seguros.each do |seguro|
        seguro.arquivo_id = @arquivo.id
        seguro.save!
        seguro.baixar_arquivos!
      end
      #
      if @arquivo.tipo == 'R'
        Seguro.gera_arquivo_remessa_residencial(@arquivo)
      else
        Seguro.gera_arquivo_remessa_comercial(@arquivo)
      end
      flash[:notice] =  "Arquivos baixados"
      @arquivo.total = @arquivo.seguros.size
      if @arquivo.save
        redirect_to admin_arquivos_path, notice: t(:created, name: 'Arquivo') 
      else
        render action: 'new' 
      end
    else
      render action: 'new' 
    end
  end

  # PUT /arquivos/1
  # PUT /arquivos/1.xml
  def update
    if @arquivo.update(arquivo_params)
      redirect_to admin_arquivos_path, notice: t(:created, name: 'Arquivo') 
    else
      render action: 'edit' 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_arquivo
      @arquivo = Arquivo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def arquivo_params
      params.require(:arquivo).permit(:codigo_sucursal, :codigo_corretor, :codigo_colaborador, :codigo_susep, 
                                      :tipo_de_pessoa, :razao_social, :codigo_da_inspetoria, :codigo_do_inspetor, 
                                      :email_corretor, :ddd_corretor, :telefone_corretor, :iof, :endereco, :numero, 
                                      :complemento, :bairro, :cidade, :uf, :cep, :imobiliaria_id, :tipo)
    end
end