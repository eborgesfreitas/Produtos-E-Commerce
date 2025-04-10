--CTE freq calcula a quantidade de pedidos e a frequência relativa a cada hora do dia
WITH freq AS ( 
	SELECT
		order_hour_of_day AS horas_do_dia,
		COUNT(product_id) AS qtd_pedidos,
		count(product_id) * 1.0  / (SELECT count(*) FROM pao_de_mel.compras) AS freq_relativa
	FROM
		pao_de_mel.compras c 
	GROUP BY
		c.order_hour_of_day --agrupamento por hora do dia
)
SELECT
	horas_do_dia,
	qtd_pedidos,
	freq_relativa,
	SUM(freq_relativa) OVER (ORDER BY freq_relativa DESC) AS freq_acumulada -- cálculo da frequência acumulada
FROM
	freq
ORDER BY
	qtd_pedidos DESC --ordenamento por quantidade de pedidos decrescente, de forma que as horas com mais pedidos apareçam primeiro
	
	
	