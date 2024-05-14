class CorrigirResumoTransmitidoem < ActiveRecord::Migration
  def change
execute "-- Function: public.fnc_resumo_seguros_imob_completo(character varying, integer)

-- DROP FUNCTION public.fnc_resumo_seguros_imob_completo(character varying, integer);

CREATE OR REPLACE FUNCTION public.fnc_resumo_seguros_imob_completo(
    tipo character varying,
    imob integer)
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
       and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 

    -- 3 mes anterior
     select date_part('month', current_date - interval '3 month') into vmes;
     select date_part('year', current_date  - interval '3 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 


    -- 4 mes anterior
     select date_part('month', current_date - interval '4 month') into vmes;
     select date_part('year', current_date  - interval '4 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 

    -- 5 mes anterior
     select date_part('month', current_date - interval '5 month') into vmes;
     select date_part('year', current_date  - interval '5 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 

    -- 6 mes anterior
     select date_part('month', current_date - interval '6 month') into vmes;
     select date_part('year', current_date  - interval '6 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 

    -- 7 mes anterior
     select date_part('month', current_date - interval '7 month') into vmes;
     select date_part('year', current_date  - interval '7 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 

    -- 8 mes anterior
     select date_part('month', current_date - interval '8 month') into vmes;
     select date_part('year', current_date  - interval '8 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 

    -- 9 mes anterior
     select date_part('month', current_date - interval '9 month') into vmes;
     select date_part('year', current_date  - interval '9 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 

    -- 10 mes anterior
     select date_part('month', current_date - interval '10 month') into vmes;
     select date_part('year', current_date  - interval '10 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 

    -- 11 mes anterior
     select date_part('month', current_date - interval '11 month') into vmes;
     select date_part('year', current_date  - interval '11 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 
    return;
 end;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.fnc_resumo_seguros_imob_completo(character varying, integer)
  OWNER TO postgres;


-- Function: public.fnc_resumo_seguros_imob_completo(character varying, integer)

-- DROP FUNCTION public.fnc_resumo_seguros_imob_completo(character varying, integer);

CREATE OR REPLACE FUNCTION public.fnc_resumo_seguros_imob_completo(
    tipo character varying,
    imob integer)
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
       and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 

    -- 3 mes anterior
     select date_part('month', current_date - interval '3 month') into vmes;
     select date_part('year', current_date  - interval '3 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 


    -- 4 mes anterior
     select date_part('month', current_date - interval '4 month') into vmes;
     select date_part('year', current_date  - interval '4 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 

    -- 5 mes anterior
     select date_part('month', current_date - interval '5 month') into vmes;
     select date_part('year', current_date  - interval '5 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 

    -- 6 mes anterior
     select date_part('month', current_date - interval '6 month') into vmes;
     select date_part('year', current_date  - interval '6 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 

    -- 7 mes anterior
     select date_part('month', current_date - interval '7 month') into vmes;
     select date_part('year', current_date  - interval '7 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 

    -- 8 mes anterior
     select date_part('month', current_date - interval '8 month') into vmes;
     select date_part('year', current_date  - interval '8 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 

    -- 9 mes anterior
     select date_part('month', current_date - interval '9 month') into vmes;
     select date_part('year', current_date  - interval '9 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 

    -- 10 mes anterior
     select date_part('month', current_date - interval '10 month') into vmes;
     select date_part('year', current_date  - interval '10 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 

    -- 11 mes anterior
     select date_part('month', current_date - interval '11 month') into vmes;
     select date_part('year', current_date  - interval '11 month') into vano;
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
    where date_part('month', transmitido_em) = vmes and date_part('year', transmitido_em) = vano
      and tipo_de_seguro = tipo and status in (1,2) and imobiliaria_id = imob;
    reg.status := 'Transmitido';
    return next reg; 
    return;
 end;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.fnc_resumo_seguros_imob_completo(character varying, integer)
  OWNER TO postgres;

"
  end
end
