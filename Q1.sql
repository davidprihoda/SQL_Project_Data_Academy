-- Q1 Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
SELECT
	avg(payroll_value) AS avg_payroll_value,
	payroll_year,
	industry_branch_code
FROM t_david_prihoda_project_sql_primary_final AS primaryt
GROUP BY payroll_year, industry_branch_code
ORDER BY industry_branch_code, payroll_year DESC;

-- Toto je řešení posyktující základní přehled. Ale stále nemám odpověď na otázku,
-- mohu listovat daty, ale to je zdlouhavé, jak tedy postupovat dál?
SELECT
	avg(payroll_value) AS avg_payroll_value,
	payroll_year,
	industry_branch_code,
	avg(payroll_value) / LAG(avg(payroll_value)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) AS payroll_change
FROM t_david_prihoda_project_sql_primary_final AS primaryt
GROUP BY payroll_year, industry_branch_code
ORDER BY industry_branch_code, payroll_year DESC;

-- Dotaz napsaný výše mi ukazuje meziroční přírůstky, což je užitečné, ale potřebuji vyfiltrovat situace, kdy k přírůstku nedošlo.
-- K tomu použiji CTE
WITH p_change AS
(SELECT
	avg(payroll_value) AS avg_payroll_value,
	payroll_year,
	industry_branch_code,
	avg(payroll_value) / LAG(avg(payroll_value)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) AS payroll_change
FROM t_david_prihoda_project_sql_primary_final AS primaryt
GROUP BY payroll_year, industry_branch_code
ORDER BY industry_branch_code, payroll_year DESC)
SELECT
	avg_payroll_value,
	payroll_year,
	industry_branch_code,
	payroll_change
FROM p_change
	WHERE payroll_change < 1;

--Hotovo, funguje to.
