class Admin::CorretorasController < AdminController
  #before_filter :login_required 
  before_filter :load_tipo_pessoa, except: :index
  before_filter :set_corretora, only: [:show, :edit, :update, :destroy]

  skip_load_resource only: [:new, :create]

  def index
    @corretoras = Corretora.order(:id)
  end

  # GET /corretoras/new
  # GET /corretoras/new.xml
  def new
    @corretora = Corretora.new
  end

  # GET /corretoras/1/edit
  def edit
  end

  # POST /corretoras
  # POST /corretoras.xml
  def create
    @corretora = Corretora.new(corretora_params)
    respond_to do |format|
      if @corretora.save
        format.html { redirect_to edit_admin_corretora_path(@corretora), notice: t(:created, name: 'Corretora') }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @corretora.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /corretoras/1
  # PUT /corretoras/1.xml
  def update
    respond_to do |format|
      if @corretora.update(corretora_params)
        format.html { redirect_to edit_admin_corretora_path(@corretora), notice: t(:updated, name: 'Corretora') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @corretora.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /corretoras/1
  # DELETE /corretoras/1.xml
  def destroy
    @corretora.destroy
    respond_to do |format|
      format.html { redirect_to corretoras_path, notice: t(:destroyed, name: 'Corretora') }
      format.xml  { head :no_content }
    end
  end

  def load_tipo_pessoa
    @tipo_pessoa = [['Física','F'],['Jurídica', 'J']]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_corretora
      @corretora = Corretora.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def corretora_params
      params.require(:corretora).permit!
    end

end