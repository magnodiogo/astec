class Admin::FaqsController < AdminController

  before_action :set_faq, only: [:edit, :update, :destroy]
  skip_load_resource only: [:new, :create]

  # GET /faqs/1
  # GET /faqs/1.xml
  def show
  end

  # GET /faqs/new
  # GET /faqs/new.xml
  def new
    @faq = Faq.new
  end

  # GET /faqs/1/edit
  def edit
  end

  # POST /faqs
  # POST /faqs.xml
  def create
    @faq = Faq.new(faq_params)
    if @faq.save
      redirect_to admin_faqs_path, notice: t(:created, name: 'FAQ') 
    else
      render action: 'new' 
    end
  end

  # PUT /faqs/1
  # PUT /faqs/1.xml
  def update
    if @faq.update(faq_params)
      redirect_to admin_faqs_path, notice: t(:updated, name: 'FAQ') 
    else
      render action: 'edit' 
    end
  end

  # DELETE /faqs/1
  # DELETE /faqs/1.xml
  def destroy
    @faq.destroy
    redirect_to admin_faqs_path, notice: t(:destroyed, name: 'FAQ') 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_faq
      @faq = Faq.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def faq_params
      params.require(:faq).permit(:pergunta, :resposta)
    end
end
