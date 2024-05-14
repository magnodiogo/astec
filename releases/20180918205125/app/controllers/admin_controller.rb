class AdminController < ApplicationController
  load_and_authorize_resource
  layout 'application'
end

=begin
class AdminController < ApplicationController
   before_filter :login_required 
   before_filter :admin_required 

   def index
   end

   def relatorios
      cond = []
      if params[:status].to_i == 1
         cond << "status in (1,2) and transmitido_em::date between ? and ? "
      elsif params[:status].to_i == 3
         cond << "status = 3 and data_limite_renovacao::date between ? and ? "
      else
         cond << "status in (?) and created_at::date between ? and ? "
         cond << (params[:status].to_i == 2 ? [0,1,2] : 0)
      end
      cond << params[:data_inicial].to_date
      cond << params[:data_final].to_date

      if params[:todas].blank? and !params[:imobiliarias].blank?
         cond[0] += " and imobiliaria_id in (?)"
         cond << params[:imobiliarias]
      end
           
      if /Endereco/.match(params[:relatorio]).nil? and /Renovacao/.match(params[:relatorio]).nil?
         select = "imobiliaria_id, tipo_de_seguro, count(id), sum(premio_total)"
         group = "imobiliaria_id, tipo_de_seguro"
         order = '1 asc, 2 desc '
         if !(/Produtor/.match(params[:relatorio]).nil?)
            select += ', transmitido_por_id'
            group  += ', transmitido_por_id'
            order  =  '1 asc, transmitido_por_id, 2 desc'
         end
         @seguros = Seguro.all(:select => select, :conditions => cond, :group => group, :order => order)     
      else
         order = "imobiliaria_id asc, tipo_de_seguro desc, transmitido_por_id"
         @seguros = Seguro.all(:conditions => cond, :order => order) 


         @total_residencial = @premio_total_residencial = @total_empresarial = @premio_total_empresarial = 0
         @seguros.each do |s|
            if s.tipo_de_seguro == 'R'
               @total_residencial += 1 
               @premio_total_residencial += s.premio_total
            else
               @total_empresarial += 1 
               @premio_total_empresarial += s.premio_total
            end
         end
      end
 

      render :template => "admin/" + params[:relatorio].gsub(' ','_').downcase, :layout => false

   end

   def alterar_plano_de_fundo
   end

   def enviar_plano_de_fundo

      name =  'bg_session.jpg'
      directory = $DIR
      directory = "#{RAILS_ROOT}/public/img/"
     
      name = 'logo_session.png'
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(params[:imagem].read) }

      redirect_to :action => :alterar_plano_de_fundo
      return
   end

   def gerar_arquivos
     a = Arquivo.new
     a.save
     ids  = params[:marcado]
     @seguros = Seguro.all(:conditions => ["id in (?)",ids ])
     unless @seguros.blank?
        @seguros.each do |s|
           s.arquivo_id = a.id
           s.save!
           s.baixar_arquivos!
        end
        # verifica o tipo de seguro para a geracao do arquivo
        if @seguros[0].tipo_de_seguro == 'R' 
           Seguro.gera_arquivo_remessa_residencial(a)
        else
           Seguro.gera_arquivo_remessa_comercial(a) 
        end 
        flash[:notice] =  "Arquivos baixados"
     end
     a.total = a.seguros.size
     a.save
     
     redirect_to arquivos_path
     return
   end

   def gerador_de_arquivos
     load_imobiliarias
     load_tipo

     if params[:imobiliaria].present? or params[:tipo].present?
        if params[:imobiliaria].blank? or params[:tipo].blank?
           flash[:error] = "Campo Imobiliária e Tipo são obrigatóriios."
           @seguros = Seguro.find_all_by_id -1
        else
           @seguros = Seguro.find(:all, :conditions => ["tipo_de_seguro = ? and imobiliaria_id = ? and status in (1,2)", params['tipo'],params['imobiliaria']], :order => 'transmitido_em desc').paginate(:page => params[:page], :per_page => 50)
        end
     else
       @seguros = Seguro.find_all_by_id -1
     end
   end

   def load_imobiliarias
    @imobiliarias = [['Selecione uma imobiliária', nil]]
    im = Imobiliaria.find_by_sql('select * from imobiliarias order by estipulante')
    im.each {|i| @imobiliarias << [i.estipulante, i.id]}
   end

   def load_tipo
    @tipos = [['Selecione', nil], ['Prédio - Residencial', 'R'], ['Prédio - Comercial', 'C']]
   end

   def coberturas_pendentes
     con = ActiveRecord::Base.connection
     sql = "select * from vw_coberturas_pendentes;"
     res = con.execute sql
     @resultado = res.to_a
     
     render :layout => false    
   end

end
=end
