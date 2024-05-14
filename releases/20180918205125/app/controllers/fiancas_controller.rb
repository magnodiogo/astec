class FiancasController < ApplicationController
  # GET /fiancas
  # GET /fiancas.xml
  def index
    @fiancas = Fianca.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fiancas }
    end
  end

  # GET /fiancas/1
  # GET /fiancas/1.xml
  def show
    @fianca = Fianca.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fianca }
    end
  end

  # GET /fiancas/new
  # GET /fiancas/new.xml
  def new
    @fianca = Fianca.new
  end

  # GET /fiancas/1/edit
  def edit
    @fianca = Fianca.find(params[:id])
  end

  # POST /fiancas
  # POST /fiancas.xml
  def create
    @fianca = Fianca.new(params[:fianca])

    if @fianca.save
      redirect_to @fianca, notice: t(:created, name: 'Fiança') 
    else
      render :action => "new" 
    end
  end

  # PUT /fiancas/1
  # PUT /fiancas/1.xml
  def update
    @fianca = Fianca.find(params[:id])

    if @fianca.update_attributes(params[:fianca])
      redirect_to @fianca, notice: t(:updated, name: 'Fiança') 
    else
      render :action => "edit" 
    end
  end

  # DELETE /fiancas/1
  # DELETE /fiancas/1.xml
  def destroy
    @fianca = Fianca.find(params[:id])
    @fianca.destroy

    redirect_to(fiancas_url) 
  end
end
