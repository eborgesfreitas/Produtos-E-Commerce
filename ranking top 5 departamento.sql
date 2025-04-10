--CTE freq agrupa as vendas por produto dentro de cada departamento e calcula a frequência relativa.
WITH freq AS (
    SELECT 
        d.department, 
        p.product_name,
        COUNT(c.product_id) AS qtd_pedidos,
        COUNT(c.product_id) * 1.0 / SUM(COUNT(c.product_id)) OVER (PARTITION BY d.department) AS freq_relativa
    FROM pao_de_mel.compras c
    LEFT JOIN pao_de_mel.produtos p 
		ON c.product_id = p.product_id
	LEFT JOIN pao_de_mel.departamentos d 
		ON d.department_id = p.department_id
    GROUP BY d.department, p.product_name
), 
-- CTE ranking_produtos ordena os produtos dentro de cada departamento e calcula o ranking com frequência acumulada.
ranking_produtos AS (
    SELECT 
        department,
        product_name,
        qtd_pedidos,
        freq_relativa,
        SUM(freq_relativa) OVER (PARTITION BY department ORDER BY qtd_pedidos DESC) AS freq_acumulada,
        RANK() OVER (PARTITION BY department ORDER BY qtd_pedidos DESC) AS ranking --ranking de pedidos por departamento
    FROM freq
)
--Filtra apenas os TOP 5 produtos mais vendidos dentro de cada departamento e os exibe ordenadamente. freq relativa e acumulada em referencia aos departamentos
SELECT 
    department,
    ranking,
    product_name, 
    qtd_pedidos, 
    freq_relativa, 
    freq_acumulada
FROM ranking_produtos
WHERE ranking <= 5
ORDER BY department, ranking