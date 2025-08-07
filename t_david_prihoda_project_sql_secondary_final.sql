--Tvorba sekundární tabulky
CREATE TABLE t_david_prihoda_project_SQL_secondary_final AS 
SELECT 
	e.country,
	e.YEAR,
	e.gdp,
	e.population,
	e.gini,
	e.taxes,
	e.fertility,
	e.mortaliy_under5,
	c.population_density,
	c.surface_area,
	c.yearly_average_temperature,
	c.median_age_2018
FROM economies e 
JOIN countries c 
ON e.country = c.country 
WHERE c.continent = 'Europe';