/*1.    Análises Exploratórias que respondam ao menos as seguintes perguntas:

a.     Qual a distribuição de vendas por:

                                               i.     Departamento de produtos

                                             ii.     Dia de semana

                                            iii.     Hora do dia

b.     Ranking TOP 5 Produtos mais vendidos por departamento (com frequência relativa e acumulada)

c.     Existe alguma concentração de tipo de produto por hora do dia em que é vendido? Ex: Pizza se compra a noite? Itens de café na parte da manhã ?*/






--CTE freq calcula a quantidade de pedidos e a frequência relativa por departamento.
WITH freq AS ( 
	SELECT 
		d.department AS departamento,
		count(c.product_id) AS qtd_pedidos,
		CAST(count(c.product_id) AS float)  / CAST((SELECT count(*) FROM pao_de_mel.compras)AS float) AS freq_relativa
	FROM
		pao_de_mel.compras c
			LEFT JOIN pao_de_mel.produtos p 
				ON c.product_id = p.product_id
			LEFT JOIN pao_de_mel.departamentos d 
				ON d.department_id = p.department_id
	GROUP BY d.department --agrupamento por departamento
)
SELECT	
	departamento,
	qtd_pedidos,
	freq_relativa,
	SUM(freq_relativa) OVER (ORDER BY freq_relativa DESC) AS freq_acumulada -- cálculo da frequência acumulada
FROM
	freq
ORDER BY qtd_pedidos DESC --ordenando pela quantidade de pedidos para os departamentos de maiores vendas aparecerem primeiro








