class Admin::SegurosController < AdminController
  skip_before_filter :authenticate_user!, only: :calcula_premio
  #before_filter :load_residencia, :load_tipo_pessoa, :load_cobertura, :load_atividades
  #before_filter :admin_required, :except => [:new, :create, :update, :edit, :show, :comercial, :residencial, :desfazer_transmitir, 
  #                                           :index, :inicio, :calcula_premio, :transmitir, :cobertura, :destroy, :faqs ]

  def coberturas_pendentes
    @resultado = Seguro.find_by_sql("SELECT i.estipulante,
                                            CASE s.tipo_de_seguro
                                                WHEN 'C'::text THEN 'EMPRESARIAL'::text
                                                WHEN 'R'::text THEN 'RESIDENCIAL'::text
                                                ELSE NULL::text
                                            END AS tipo_de_seguro,
                                        count(s.id) AS quantidade
                                       FROM seguros s
                                         JOIN imobiliarias i ON i.id = s.imobiliaria_id
                                      WHERE s.status = 1
                                      GROUP BY i.estipulante, s.tipo_de_seguro
                                      ORDER BY 1,
                                            CASE s.tipo_de_seguro
                                                WHEN 'C'::text THEN 'EMPRESARIAL'::text
                                                WHEN 'R'::text THEN 'RESIDENCIAL'::text
                                                ELSE NULL::text
                                            END;")
    #@resultado = Seguro.find_by_sql("select * from vw_coberturas_pendentes;")
    render layout: false    
  end
  
  def relatorios
    if request.post?
      cond = []
      if params[:status].to_i == 1
        cond << "status in (1,2) and transmitido_em between ? and ? "
      elsif params[:status].to_i == 3
        cond << "status = 3 and data_limite_renovacao::date between ? and ? "
      else
        cond << "status in (?) and created_at::date between ? and ? "
        cond << (params[:status].to_i == 2 ? [0,1,2] : 0)
      end
      cond << params[:data_inicial].to_date.beginning_of_day
      cond << params[:data_final].to_date.end_of_day



      if params[:todas].blank? and !params[:imobiliarias].blank?
        cond[0] += " and imobiliaria_id in (?)"
        cond << params[:imobiliarias]
      end

      if /Endereco/.match(params[:relatorio]).nil? and /Renovacao/.match(params[:relatorio]).nil?
        select = "imobiliaria_id, tipo_de_seguro, count(id), sum(premio_total)"
        group = "imobiliaria_id, tipo_de_seguro"
        order = '1 asc, 2 desc '
        if !(/Produtor/.match(params[:relatorio]).nil?)
          select  += ', transmitido_por_id'
          group   += ', transmitido_por_id'
          order    =  'imobiliaria_id asc, transmitido_por_id, tipo_de_seguro desc'
        end
        @seguros = Seguro.select(select).where(cond).group(group).order(order).includes(:imobiliaria)
      else
        order = "imobiliaria_id asc, tipo_de_seguro desc, transmitido_por_id"
        @seguros = Seguro.where(cond).order(order).includes(:imobiliaria)


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
      respond_to do |format|
        format.html { render :template => "admin/seguros/" + params[:relatorio].gsub(' ','_').downcase, :layout => false }
        format.xlsx
      end
    end
  end

  def renovacoes
    if request.post?
      @seguros = nil
      if params[:ids].present?
        @ids = params[:ids].join(', ')
      elsif params[:imobiliaria_id].present?
        cond = ["imobiliaria_id = ? and date_part('YEAR', transmitido_em) = ? and date_part('MONTH', transmitido_em) = ?"]
        cond << params[:imobiliaria_id]
        cond << params[:ano]
        cond << params[:mes]
        @seguros = Seguro.where(cond).order("tipo_de_seguro asc, transmitido_em asc").includes(:logradouro)
      else
        redirect_to :back, notice: "Renovação não encontrada"
      end
    end
  end

  def gerar_renovacoes
    if params[:ids].present? and params[:renovar_ate].present?
      ids  = params[:ids]
      data = params[:renovar_ate].to_date
      
      Seguro.where("id in (?)", ids.split(', ')).each do |s|
        s.gerar_renovacao(data)
      end
      criadas = Seguro.where(["parent_id in (?)", ids.split(', ')]).count
      redirect_to renovacoes_admin_seguros_path, notice: "#{criadas} renovações cadastradas."
    end
  end
end
