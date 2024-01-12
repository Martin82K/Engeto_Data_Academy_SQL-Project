CREATE TABLE
    t_martin_kalkus_project_SQL_secondary_final
SELECT
    e.`year`,
    c.country,
    c.population,
    e.GDP,
    e.gini
FROM countries c
    LEFT JOIN economies e ON c.country = e.country
WHERE
    e.GDP IS NOT NULL
    OR e.gini IS NOT NULL
ORDER BY country, e.`year`;