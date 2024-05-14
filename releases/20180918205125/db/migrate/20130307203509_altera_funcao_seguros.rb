class AlteraFuncaoSeguros < ActiveRecord::Migration
  def self.up
    execute "CREATE OR REPLACE FUNCTION fnc_resumo_seguros(tipo character varying)
  RETURNS SETOF tp_resumo_seguros AS
$BODY$
 declare
    vmes integer;
    vano integer;
    reg tp_resumo_seguros;
 begin
     -- comecando pelo mes atual
     select date_part('month', current_date) into vmes;
     select date_part('year', current_date) into vano;
     case 
       when vmes = 1 then reg.mes := 'Janeiro de '::varchar || vano::varchar;
       when vmes = 2 then reg.mes := 'Fevereiro de '::varchar || vano::varchar;
       when vmes = 3 then reg.mes := 'Março de '::varchar || vano::varchar;
       when vmes = 4 then reg.mes := 'Abril de '::varchar || vano::varchar;
       when vmes = 5 then reg.mes := 'Maio de '::varchar || vano::varchar;
       when vmes = 6 then reg.mes := 'Junho de '::varchar || vano::varchar;
       when vmes = 7 then reg.mes := 'Julho de '::varchar || vano::varchar;
       when vmes = 8 then reg.mes := 'Agosto de '::varchar || vano::varchar;
       when vmes = 9 then reg.mes := 'Setembro de '::varchar || vano::varchar;
       when vmes = 10 then reg.mes := 'Outubro de '::varchar || vano::varchar ;
       when vmes = 11 then reg.mes := 'Novembro de '::varchar || vano::varchar;
       when vmes = 12 then reg.mes := 'Dezembro de '::varchar || vano::varchar;
     end case;
    -- soma dos seguros
    select sum(premio_total) into reg.valor from seguros 
    where date_part('month', created_at) = vmes and date_part('year', created_at) = vano
       and tipo_de_seguro = tipo and status = 1 ;
    reg.status := 'Em Aberto';
    return next reg; 
    -- mes anterior
     select date_part('month', current_date - interval '1 month') into vmes;
     select date_part('year', current_date  - interval '1 month') into vano;
     case 
       when vmes = 1 then reg.mes := 'Janeiro de '::varchar || vano::varchar;
       when vmes = 2 then reg.mes := 'Fevereiro de '::varchar || vano::varchar;
       when vmes = 3 then reg.mes := 'Março de '::varchar || vano::varchar;
       when vmes = 4 then reg.mes := 'Abril de '::varchar || vano::varchar;
       when vmes = 5 then reg.mes := 'Maio de '::varchar || vano::varchar;
       when vmes = 6 then reg.mes := 'Junho de '::varchar || vano::varchar;
       when vmes = 7 then reg.mes := 'Julho de '::varchar || vano::varchar;
       when vmes = 8 then reg.mes := 'Agosto de '::varchar || vano::varchar;
       when vmes = 9 then reg.mes := 'Setembro de '::varchar || vano::varchar;
       when vmes = 10 then reg.mes := 'Outubro de '::varchar || vano::varchar ;
       when vmes = 11 then reg.mes := 'Novembro de '::varchar || vano::varchar;
       when vmes = 12 then reg.mes := 'Dezembro de '::varchar || vano::varchar;
     end case;
    -- soma dos seguros
    select sum(premio_total) into reg.valor from seguros 
    where date_part('month', created_at) = vmes and date_part('year', created_at) = vano
      and tipo_de_seguro = tipo and status = 1;
    reg.status := 'Transmitido';
    return next reg; 

    -- 2 mes anterior
     select date_part('month', current_date - interval '2 month') into vmes;
     select date_part('year', current_date  - interval '2 month') into vano;
     case 
       when vmes = 1 then reg.mes := 'Janeiro de '::varchar || vano::varchar;
       when vmes = 2 then reg.mes := 'Fevereiro de '::varchar || vano::varchar;
       when vmes = 3 then reg.mes := 'Março de '::varchar || vano::varchar;
       when vmes = 4 then reg.mes := 'Abril de '::varchar || vano::varchar;
       when vmes = 5 then reg.mes := 'Maio de '::varchar || vano::varchar;
       when vmes = 6 then reg.mes := 'Junho de '::varchar || vano::varchar;
       when vmes = 7 then reg.mes := 'Julho de '::varchar || vano::varchar;
       when vmes = 8 then reg.mes := 'Agosto de '::varchar || vano::varchar;
       when vmes = 9 then reg.mes := 'Setembro de '::varchar || vano::varchar;
       when vmes = 10 then reg.mes := 'Outubro de '::varchar || vano::varchar ;
       when vmes = 11 then reg.mes := 'Novembro de '::varchar || vano::varchar;
       when vmes = 12 then reg.mes := 'Dezembro de '::varchar || vano::varchar;
     end case;
    -- soma dos seguros
    select sum(premio_total) into reg.valor from seguros 
    where date_part('month', created_at) = vmes and date_part('year', created_at) = vano
      and tipo_de_seguro = tipo and status = 1;
    reg.status := 'Transmitido';
    return next reg; 
    return;

     
 end;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
"
  end

  def self.down
  end
end
