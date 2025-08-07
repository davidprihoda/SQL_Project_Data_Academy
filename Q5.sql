-- 5.	Má výška HDP vliv na změny ve mzdách a cenách potravin?
-- Neboli, pokud HDP vzroste výrazněji v jednom roce, 
-- projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
SELECT 
	round(avg(tdppspf.product_price)::NUMERIC, 2) AS avg_product_price,
	avg(tdppspf.product_price) / LAG(avg(tdppspf.product_price)) OVER (ORDER BY tdppspf.payroll_year) AS price_change,
	tdppspf.payroll_year AS year,
	round(avg(tdppspf.payroll_value)::NUMERIC, 2) AS avg_payroll,
	avg(tdppspf.payroll_value) / LAG(avg(tdppspf.payroll_value)) OVER (ORDER BY tdppspf.payroll_year) AS payroll_change,
	tdppssf.gdp,
	tdppssf.gdp / LAG (tdppssf.gdp) OVER (ORDER BY tdppspf.payroll_year) AS gdp_change
FROM t_david_prihoda_project_sql_primary_final tdppspf 
JOIN t_david_prihoda_project_sql_secondary_final tdppssf 
	ON tdppspf.payroll_year = tdppssf."year" 
	AND tdppssf.country = 'Czech Republic'
GROUP BY tdppspf.payroll_year, tdppssf.gdp
ORDER BY tdppspf.payroll_year DESC;

-- Mám propojenou primární a sekundární tabulku dle roku. Ze sekundární tabulky bylo doplněno GDP.
-- Musím prozkoumat vztahy, budu počítat korelaci mezi přřírůstky GDP, průměrných mezd a cen.
WITH product_payroll_gdp AS 
(SELECT 
	round(avg(tdppspf.product_price)::NUMERIC, 2) AS avg_product_price,
	avg(tdppspf.product_price) / LAG(avg(tdppspf.product_price)) OVER (ORDER BY tdppspf.payroll_year) AS price_change,
	tdppspf.payroll_year AS year,
	round(avg(tdppspf.payroll_value)::NUMERIC, 2) AS avg_payroll,
	avg(tdppspf.payroll_value) / LAG(avg(tdppspf.payroll_value)) OVER (ORDER BY tdppspf.payroll_year) AS payroll_change,
	tdppssf.gdp,
	tdppssf.gdp / LAG (tdppssf.gdp) OVER (ORDER BY tdppspf.payroll_year) AS gdp_change
FROM t_david_prihoda_project_sql_primary_final tdppspf 
JOIN t_david_prihoda_project_sql_secondary_final tdppssf 
	ON tdppspf.payroll_year = tdppssf."year" 
	AND tdppssf.country = 'Czech Republic'
GROUP BY tdppspf.payroll_year, tdppssf.gdp
ORDER BY tdppspf.payroll_year DESC)
SELECT 
	CORR (price_change, gdp_change) AS price_gdp_corr,
	CORR (payroll_change, gdp_change) AS payroll_gdp_corr,
	CORR (price_change, payroll_change) AS price_payroll_corr
FROM product_payroll_gdp;

-- Pojďme se podívat na korelace HDP, cen produktů a průměrných mezd, nikoli přírůstků.

WITH product_payroll_gdp AS 
(SELECT 
	round(avg(tdppspf.product_price)::NUMERIC, 2) AS avg_product_price,
	avg(tdppspf.product_price) / LAG(avg(tdppspf.product_price)) OVER (ORDER BY tdppspf.payroll_year) AS price_change,
	tdppspf.payroll_year AS year,
	round(avg(tdppspf.payroll_value)::NUMERIC, 2) AS avg_payroll,
	avg(tdppspf.payroll_value) / LAG(avg(tdppspf.payroll_value)) OVER (ORDER BY tdppspf.payroll_year) AS payroll_change,
	tdppssf.gdp,
	tdppssf.gdp / LAG (tdppssf.gdp) OVER (ORDER BY tdppspf.payroll_year) AS gdp_change
FROM t_david_prihoda_project_sql_primary_final tdppspf 
JOIN t_david_prihoda_project_sql_secondary_final tdppssf 
	ON tdppspf.payroll_year = tdppssf."year" 
	AND tdppssf.country = 'Czech Republic'
GROUP BY tdppspf.payroll_year, tdppssf.gdp
ORDER BY tdppspf.payroll_year DESC)
SELECT
	CORR (avg_product_price, gdp) AS price_gdp_corr,
	CORR (avg_payroll, gdp) AS payroll_gdp_corr,
	CORR (avg_product_price, avg_payroll) AS price_payroll_corr
FROM product_payroll_gdp;
