-- 2.	Kolik je možné si koupit litrů mléka a kilogramů chleba 
-- za první a poslední srovnatelné období v dostupných datech cen a mezd?
SELECT 
	round(avg(product_price)::NUMERIC, 2) AS avg_product_price,
	round(avg(payroll_value)::NUMERIC, 2) AS avg_payroll_value,
	payroll_year AS year,
	product_category_code,
	round(avg(payroll_value)/avg(product_price)::NUMERIC, 2) AS product_per_payroll
FROM t_david_prihoda_project_sql_primary_final tdppspf
WHERE product_category_code IN (111301, 114201)
	AND payroll_year IN (2006, 2018)
GROUP BY payroll_year, product_category_code
ORDER BY product_category_code, payroll_year DESC ;

-- Z dat je vidět pomocí seřazení let vzestupně a sestupně, že prvním měřitelným rokem je 2006 a posledním 2018.
-- Proto je snadné rok 2006 a 2018 zadat do WHERE filtru. Ale co když rok neznám?
SELECT 
	round(avg(product_price)::NUMERIC, 2) AS avg_product_price,
	round(avg(payroll_value)::NUMERIC, 2) AS avg_payroll_value,
	payroll_year AS year,
	product_category_code,
	round(avg(payroll_value)/avg(product_price)::NUMERIC, 2) AS product_per_payroll
FROM t_david_prihoda_project_sql_primary_final tdppspf
WHERE product_category_code IN (111301, 114201)
	AND payroll_year IN 
		((SELECT min(payroll_year) FROM t_david_prihoda_project_sql_primary_final tdppspf2),
		(SELECT max(payroll_year) FROM t_david_prihoda_project_sql_primary_final tdppspf2))
GROUP BY payroll_year, product_category_code
ORDER BY product_category_code, payroll_year DESC;

-- Hotovo, ale získaný obrázek je velmi obecný, pro hlubší pohled je lepší podívat se ještě na jednotlivá průmyslová odvětví.
SELECT 
	round(avg(product_price)::NUMERIC, 2) AS avg_product_price,
	round(avg(payroll_value)::NUMERIC, 2) AS avg_payroll_value,
	payroll_year AS year,
	product_category_code,
	industry_branch_code,
	round(avg(payroll_value)/avg(product_price)::NUMERIC, 2) AS product_per_payroll
FROM t_david_prihoda_project_sql_primary_final tdppspf
WHERE product_category_code IN (111301, 114201)
	AND payroll_year IN 
		((SELECT min(payroll_year) FROM t_david_prihoda_project_sql_primary_final tdppspf2),
		(SELECT max(payroll_year) FROM t_david_prihoda_project_sql_primary_final tdppspf2))
GROUP BY payroll_year, product_category_code, industry_branch_code 
ORDER BY product_category_code, payroll_year DESC, product_per_payroll DESC ;