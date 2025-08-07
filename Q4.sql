-- 4.	Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší 
-- než růst mezd (větší než 10 %)?
SELECT
	round(avg(product_price)::NUMERIC, 2) AS avg_product_price,
	avg(product_price) / LAG(avg(product_price)) OVER (ORDER BY payroll_year) AS price_change, 
	payroll_year AS year,
	round(avg(payroll_value)::NUMERIC, 2) AS avg_payroll,
	avg(payroll_value) / LAG(avg(payroll_value)) OVER (ORDER BY payroll_year) AS payroll_change
FROM t_david_prihoda_project_sql_primary_final tdppspf
GROUP BY payroll_year
ORDER BY payroll_year DESC;

-- Mám tabulku s průměrnými cenami a mzdami za jednotlivé roky včetně meziročních přírůstků.
-- Potřebuji podíl přírůstků a filtrovat případy s 10 % podílem.

WITH product_payroll AS 
(SELECT
	round(avg(product_price)::NUMERIC, 2) AS avg_product_price,
	avg(product_price) / LAG(avg(product_price)) OVER (ORDER BY payroll_year) AS price_change, 
	payroll_year AS year,
	round(avg(payroll_value)::NUMERIC, 2) AS avg_payroll,
	avg(payroll_value) / LAG(avg(payroll_value)) OVER (ORDER BY payroll_year) AS payroll_change
FROM t_david_prihoda_project_sql_primary_final tdppspf
GROUP BY payroll_year
ORDER BY payroll_year DESC)
SELECT
	avg_product_price,
	price_change,
	year,
	avg_payroll,
	payroll_change,
	price_change / payroll_change AS product_payroll_rate
FROM product_payroll
WHERE price_change / payroll_change > 1.1
ORDER BY year DESC;

-- Výsledkem je 0 řádků, odpověď je ne. Je ale možný opačný trend, tj mzdy rostly více než ceny potravin?

WITH product_payroll AS 
(SELECT
	round(avg(product_price)::NUMERIC, 2) AS avg_product_price,
	avg(product_price) / LAG(avg(product_price)) OVER (ORDER BY payroll_year) AS price_change, 
	payroll_year AS year,
	round(avg(payroll_value)::NUMERIC, 2) AS avg_payroll,
	avg(payroll_value) / LAG(avg(payroll_value)) OVER (ORDER BY payroll_year) AS payroll_change
FROM t_david_prihoda_project_sql_primary_final tdppspf
GROUP BY payroll_year
ORDER BY payroll_year DESC)
SELECT
	avg_product_price,
	price_change,
	year,
	avg_payroll,
	payroll_change,
	payroll_change / price_change AS payroll_product_rate
FROM product_payroll
WHERE payroll_change / price_change > 1.1
ORDER BY YEAR DESC;

-- Stalo se tak v roce 2009, kdy ceny meziročně klesly o 6,82, zatímco mzdy meziročně vzrostly o 3,16 %.