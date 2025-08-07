-- 3. Která kategorie potravin zdražuje nejpomaleji 
-- (je u ní nejnižší percentuální meziroční nárůst)?
SELECT 
	product_category_code,
	round(avg(product_price)::NUMERIC, 2) AS avg_product_price,
	payroll_year AS year,
	avg(product_price) / LAG(avg(product_price)) OVER (PARTITION BY product_category_code ORDER BY payroll_year) AS price_change
FROM t_david_prihoda_project_sql_primary_final tdppspf
GROUP BY payroll_year, product_category_code 
ORDER BY product_category_code, payroll_year DESC ;

-- Tabulka výše ukazuje meziroční přírůstky cen u jednotlivých kategorií produktů.
-- Níže pomocí CTE získáme průměrné přírůstky u jednotlivých kategorií za celé období.

WITH pr_change AS 
(SELECT 
	product_category_code,
	round(avg(product_price)::NUMERIC, 2) AS avg_product_price,
	payroll_year AS Year,
	avg(product_price) / LAG(avg(product_price)) OVER (PARTITION BY product_category_code ORDER BY payroll_year) AS price_change
FROM t_david_prihoda_project_sql_primary_final tdppspf
GROUP BY payroll_year, product_category_code 
ORDER BY product_category_code, payroll_year DESC)
SELECT
	product_category_code,
	avg(price_change) AS category_change
FROM pr_change
GROUP BY product_category_code
ORDER BY category_change;