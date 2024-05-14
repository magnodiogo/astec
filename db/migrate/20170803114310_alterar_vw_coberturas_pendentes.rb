class AlterarVwCoberturasPendentes < ActiveRecord::Migration
  def change
execute "DROP VIEW vw_coberturas_pendentes ;
CREATE OR REPLACE VIEW vw_coberturas_pendentes AS 
 SELECT i.estipulante,
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
        END;

ALTER TABLE vw_coberturas_pendentes
  OWNER TO postgres;"
  end
end
