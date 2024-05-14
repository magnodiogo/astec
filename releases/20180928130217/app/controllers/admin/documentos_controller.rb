class Admin::DocumentosController < AdminController
  before_filter :set_imobiliaria
  skip_load_resource only: [:new, :create]

  def index
    @documentos = @imobiliaria.documentos.order(:id)
    @documento = Documento.new(imobiliaria_id: @imobiliaria.id)
  end

  def create
    @documento      = Documento.new(documento_params)
    #@documento.user = current_user
    if @documento.save
      redirect_to :back, notice: 'Documento enviado com sucesso.'
    else
      render action: "new" 
    end
  end

  def destroy
    @documento = @imobiliaria.documentos.find(params[:id])
    if @documento.destroy
      redirect_to :back, notice: "Documento excluído."
    end
  end

  private
    def set_imobiliaria
      @imobiliaria = Imobiliaria.find(params[:imobiliaria_id])
    end

    def documento_params
      params.require(:documento).permit(:imobiliaria_id, :documento)
      #params.require(:documento).permit(:imobiliaria_id, :documento)
    end
end
