class Admin::LogradourosController < AdminController
  #before_filter :login_required, only: :index
  #before_filter :admin_required, only: [:index, :edit]
  before_action :set_logradouro, only: [:show, :edit, :update, :destroy]
  before_action :load_ufs_cidades, only: [:new]

  skip_load_resource only: [:new, :create]

  def index  
    @logradouro = Logradouro.new
    cond = [""]
    if params[:logradouro].present?
      @logradouro = Logradouro.new(logradouro_params)
      if @logradouro.nome_bairro.present?
        cond = ["upper(nome_bairro) like ?", "%" + @logradouro.nome_bairro.upcase  + "%"]
      end
      if @logradouro.estado_id.present?
        cond[0] += " and " unless cond[0].blank?
        cond[0] += " estado_id = ? "
        cond    << @logradouro.estado_id
      end
      if @logradouro.nome.present?
        cond[0] += " and "    if cond.size > 1
        cond[0] += "upper(logradouros.nome) like ?"
        cond    << '%' + @logradouro.nome.upcase + '%'
      end
      if @logradouro.codigo_cidade.present?
        cond[0] += " and " unless cond[0].blank?
        cond[0] += " codigo_cidade = ? "
        cond << @logradouro.codigo_cidade
      end
      if @logradouro.cep.present?
        cond[0] += " and " unless cond[0].blank?
        cond[0] += " cep like ? "
        cond    << "%" + @logradouro.cep + "%"
      end
    end

    if cond[0].present?
      @logradouros = Logradouro.where(cond).includes(:localidade).order(cep: :desc).paginate(page: params[:page])
      @cidades     = Localidade.where(estado_id: @logradouro.estado_id || 6).order(:nome)
    else 
      @logradouros = Logradouro.includes(:localidade).order(id: :desc).limit(20)
    end
    @estados     = Estado.order(:id)
  end

  def new
    @logradouro = Logradouro.new(estado_id: 6, uf: 'CE')
  end

  # GET /ceps/1/edit
  def edit
  end

  # o @cep virou @logradouro
  def create
    @logradouro = Logradouro.new(logradouro_params)
    if @logradouro.save
      redirect_to edit_admin_logradouro_path(@logradouro), notice: t(:created, name: 'CEP') 
    else
      load_ufs_cidades
      render action: 'new' 
    end
  end

  def update
    if @logradouro.update(logradouro_params)
      redirect_to edit_admin_logradouro_path(@logradouro), notice: t(:updated, name: 'CEP') 
    else
      load_ufs_cidades
      render action: 'edit' 
    end
  end

  def destroy
    if @logradouro.destroy
      redirect_to admin_logradouros_path, notice: "CEP excluído com sucesso"
    end
  end

  ################################

  def titulo_search_cep
    if request.post?
      if params[:cidade].blank?
        @ufs     = Localidade.select("distinct(uf)").order(:uf).collect{|l| l.uf }.insert(0, "") 
        @cidades = Localidade.select("distinct(nome), id").where(uf: 'AC').order(:nome).collect{|l| [l.nome,l.id] }.insert(0, '')
        flash[:error] = "Selecione a cidade para realizar a consulta"
        return
      end 
      cond = []
      cond << ''
      if params[:endereco].present?
        cond[0] += "upper(logradouros.tipo || ' ' || logradouros.nome) like ?"
        cond    << '%' + params[:endereco].upcase + '%'
      end
      if params[:nome_bairro].present?
        cond[0] += " and "    if cond.size > 1
        cond[0] += "upper(logradouros.nome_bairro) like ?"
        cond    << '%' + params[:nome_bairro].upcase + '%'
      end
      
      cond[0]  += " and "    if cond.size > 1
      cond[0]  += "l.id = ?"
      cond     << params[:cidade]

      @ceps = Logradouro.joins("join localidades l on l.codigo_correios = logradouros.codigo_cidade").where(cond).
                         order("cep asc, logradouros.nome, logradouros.complemento, logradouros.nome_bairro").limit(100)
    end
    @ufs     = Localidade.select("distinct(uf)").order(:uf).collect{|l| l.uf }.insert(0, "")
    @cidades = []
  end

  def get_bairros
    @bairros = []
    if !params[:cidade].blank?
      cidade   = Localidade.find(params[:cidade]).codigo_correios
      @bairros = Bairro.where(codigo_cidade: cidade).order(:nome).pluck(:nome, :id).insert(0,'')
    end
  end

  def get_cidades
    @cidades = Localidade.select("distinct(nome), id").where(uf: params[:uf]).order(:nome).collect{|l| [l.nome,l.id] }.insert(0,'')
  end

  def search_cep
    @tipo = params[:tipo]
    @mes  = params[:mes]
     
    if request.post?
      if params[:cidade].blank?
        @ufs     = Localidade.select("distinct(uf)").order(:uf).collect{|l| l.uf }.insert(0, "") 
        @cidades = Localidade.select("distinct(nome), id").where(uf: 'AC').order(:nome).collect{|l| [l.nome,l.id] }.insert(0,'')
        flash[:error] = "Selecione a cidade para realizar a consulta"
        return
      end 
      cond = []
      cond << ''
      if params[:endereco].present?
        cond[0] += "upper(logradouros.tipo || ' '|| logradouros.nome) like ?"
        cond    << '%' + params[:endereco].upcase + '%'
      end
      if params[:nome_bairro].present?
        cond[0]  += " and "    if cond.size > 1
        cond[0] += "upper(logradouros.nome_bairro) like ?"
        cond    << '%' + params[:nome_bairro].upcase + '%'
      end
      cond[0]  += " and "    if cond.size > 1
      cond[0]  += "l.id = ?"
      cond     << params[:cidade]
      
      @ceps = Logradouro.joins("join localidades  l on l.codigo_correios = logradouros.codigo_cidade").where(cond).
                         order("cep asc, logradouros.nome, logradouros.complemento, logradouros.nome_bairro").limit(100)
    end
    @ufs     = Localidade.select("distinct(uf)").order(:uf).collect{|l| l.uf }.insert(0, "")
    @cidades = []
  end

  #def get_bairros
  #  @bairros = Bairro.find_all_by_codigo_cidade(params[:logradouro_codigo_cidade], :order => "nome").collect{|b| [b.nome, b.codigo_correios]}
  #  render :layout => false
  #end

  def busca_endereco_fianca
    parametro = ""
    parametro = params[:fianca_imovel_cep]            if params[:fianca_imovel_cep].present?
    parametro = params[:fianca_residencia_cep]        if params[:fianca_residencia_cep].present?
    parametro = params[:fianca_correspondencia_cep]   if params[:fianca_correspondencia_cep].present?
    parametro = params[:fianca_anterior_cep]          if params[:fianca_anterior_cep].present?
    parametro = params[:fianca_bens_imoveis_cep]      if params[:fianca_bens_imoveis_cep].present?
    parametro = params[:fianca_locatario_empresa_cep] if params[:fianca_locatario_empresa_cep].present?
    l = Logradouro.where(cep: parametro.gsub('-','')).last
    if l
       @cep = l
    else
       @cep = Cep.new(tipo: "Não encontrado", nome: "")
    end
    render layout: false
  end

  def busca_endereco_por_cep
    @model = params[:seguro_cep].present? ? 'seguro' : 'titulo'
    cep    = params[:seguro_cep] || params[:titulo_cep]
    l = Logradouro.where(cep: cep.gsub('-','')).last
    if l
       @cep = l
    else
       @cep = Cep.new(tipo: "Não encontrado", nome: "")
    end
    render layout: false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_logradouro
      @logradouro = Logradouro.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def logradouro_params
      params.require(:logradouro).permit( :uf, :codigo_cidade, :codigo_bairro, :nome, :complemento, 
                                          :cep, :tipo, :nome_bairro, :complemento, :estado_id)
    end

    def load_ufs_cidades
      @estados     = Estado.order(:id)
      @cidades     = Localidade.where(estado_id: @logradouro.try(:estado_id) || 6).order(:nome)
    end
end