--CTE freq calcula a quantidade de pedidos e a frequência relativa por dia da semana
WITH freq AS ( 
	SELECT
		order_dow,
		CASE --condição para renomear os dias da semana, para que a leitura fique mais intuitiva
			WHEN order_dow = 0 THEN 'Domingo'
			WHEN order_dow = 1 THEN 'Segunda-feira'
			WHEN order_dow = 2 THEN 'Terça-feira'
			WHEN order_dow = 3 THEN 'Quarta-feira'
			WHEN order_dow = 4 THEN 'Quinta-feira'
			WHEN order_dow = 5 THEN 'Sexta-feira'
			WHEN order_dow = 6 THEN 'Sábado'
		END AS nome_do_dia,
		COUNT(product_id) AS qtd_pedidos,
		count(product_id) * 1.0  / (SELECT count(*) FROM pao_de_mel.compras) AS freq_relativa
	FROM
		pao_de_mel.compras c 
	GROUP BY
		c.order_dow --agrupamento por dia da semana
)
--consulta final para trazer os cálculos da CTE freq e calcular a frequência acumulada
SELECT
	nome_do_dia,
	qtd_pedidos,
	freq_relativa,
	SUM(freq_relativa) OVER (ORDER BY freq_relativa DESC) AS freq_acumulada -- cálculo da frequência acumulada
FROM
	freq
ORDER BY 
	qtd_pedidos DESC --ordenamento por quantidade de pedidos decrescente, para que os dias com mais pedidos apareçam primeiro.