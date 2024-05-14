class Admin::MensagensController < AdminController
  before_action :set_mensagem, only: [:show, :edit, :update, :destroy]
  skip_load_resource only: [:new, :create]

  # GET /mensagens
  # GET /mensagens.json
  def index
    @mensagens = Mensagem.order(id: :desc)
  end

  # GET /mensagens/1
  # GET /mensagens/1.json
  def show
  end

  # GET /mensagens/new
  def new
    @mensagem = Mensagem.new
  end

  # GET /mensagens/1/edit
  def edit
  end

  # POST /mensagens
  # POST /mensagens.json
  def create
    @mensagem = Mensagem.new(mensagem_params)
    if @mensagem.save
      redirect_to admin_mensagem_path(@mensagem), notice: t(:created, name: 'Mensagem')  
    else
      render :new 
    end
  end

  # PATCH/PUT /mensagens/1
  # PATCH/PUT /mensagens/1.json
  def update
    if @mensagem.update(mensagem_params)
      redirect_to admin_mensagem_path(@mensagem), notice: t(:updated, name: 'Mensagem')  
    else
      render :edit 
    end
  end

  # DELETE /mensagens/1
  # DELETE /mensagens/1.json
  def destroy
    @mensagem.destroy
    redirect_to admin_mensagens_path, notice: t(:destroyed, name: 'Mensagem') 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mensagem
      @mensagem = Mensagem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mensagem_params
      params[:mensagem]                   ||= {}
      params[:mensagem][:user_ids]        ||= []
      params[:mensagem]                   ||= {}
      params[:mensagem][:imobiliaria_ids] ||= []
      params.require(:mensagem).permit(:titulo, :texto, :ativo, :inicio, :fim, user_ids: [], imobiliaria_ids: [])
    end
end
