-- Tvorba primární tabulky
CREATE TABLE t_david_prihoda_project_SQL_primary_final AS 
SELECT
	cp.category_code AS product_category_code,
	cp.value AS product_price,
	cpc.name AS product_name,
	cpc.price_value,
	cpc.price_unit,
	cp.date_from,
	cp.date_to,
	cpay.industry_branch_code,
	cpib.name AS branch_name,
	cpay.value AS payroll_value,
	cpay.payroll_year 
FROM czechia_price cp
JOIN czechia_payroll cpay
	ON date_part('year', cp.date_from) = cpay.payroll_year
	AND cpay.value_type_code = 5958
	AND cp.region_code IS NULL
JOIN czechia_price_category cpc
	ON cp.category_code = cpc.code
JOIN czechia_payroll_industry_branch cpib
	ON cpay.industry_branch_code = cpib.code;