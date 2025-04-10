


WITH produto_por_hora AS( -- quantidade vendida e frequencia relativa DO tipo de produto por hora
	SELECT
	    c.order_hour_of_day AS hora_do_dia,
	    tdp.aisle AS tipo_de_produto,
	    COUNT(c.product_id) AS qtd_vendida,
	    -- frequencia relativa em relação a hora do dia
	    COUNT(c.product_id) * 1.0 / NULLIF(SUM(COUNT(c.product_id)) OVER (PARTITION BY c.order_hour_of_day), 0) AS freq_relativa
	FROM 
	    pao_de_mel.tipo_de_produto tdp
	    LEFT JOIN pao_de_mel.produtos p 
	        ON p.aisle_id = tdp.aisle_id
	    LEFT JOIN pao_de_mel.compras c 
	        ON c.product_id = p.product_id
	GROUP BY
	    c.order_hour_of_day, tdp.aisle -- agrupamento por hora e por tipo de produto
	ORDER BY 
	    c.order_hour_of_day ASC, freq_relativa DESC
),
ranking_por_hora AS ( -- ranking da qtd vendida dentro de cada hora
    SELECT 
        hora_do_dia,
        tipo_de_produto,
        qtd_vendida,
        freq_relativa,
        RANK() OVER (PARTITION BY hora_do_dia ORDER BY qtd_vendida DESC) AS ranking --ranking de pedidos por hora
    FROM produto_por_hora 
)
SELECT
	ranking,
	hora_do_dia,
    tipo_de_produto,
    qtd_vendida,
    freq_relativa
 FROM
 	ranking_por_hora 
WHERE 
	ranking <= 10 AND qtd_vendida > 0 -- filtrando o top10 mais vendidos com vendas maiores que 0
ORDER BY 
	hora_do_dia, qtd_vendida DESC -- ordenando por hora DO dia e pela quantidade vendida decrescente

 
	
	
    