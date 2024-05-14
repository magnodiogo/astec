class CreateVwCoberturasPendentes < ActiveRecord::Migration
  def self.up
    execute "create view vw_coberturas_pendentes as
select i.nome_fantasia, case s.tipo_de_seguro
                         when 'C' then 'EMPRESARIAL'
                         when 'R' then 'RESIDENCIAL'
                        end as tipo_de_seguro   , count(s.id) as quantidade from seguros s
join imobiliarias i on i.id = s.imobiliaria_id
where s.status = 1
group by i.nome_fantasia, s.tipo_de_seguro
order by 1,2;"
  end

  def self.down
    execute "drop view vw_coberturas_pendentes;"
  end
end
