/*
 * Primární tabulky:
 czechia_payroll – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
 czechia_payroll_calculation – Číselník kalkulací v tabulce mezd.
 czechia_payroll_industry_branch – Číselník odvětví v tabulce mezd.
 czechia_payroll_unit – Číselník jednotek hodnot v tabulce mezd.
 czechia_payroll_value_type – Číselník typů hodnot v tabulce mezd.
 czechia_price – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
 czechia_price_category – Číselník kategorií potravin, které se vyskytují v našem přehledu.
 Číselníky sdílených informací o ČR:
 czechia_region – Číselník krajů České republiky dle normy CZ-NUTS 2.
 czechia_district – Číselník okresů České republiky dle normy LAU.
 Dodatečné tabulky:
 countries - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
 economies - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.
 VÝZKUMNÉ OTÁZKY:
 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce,
 6. projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
 */

SELECT *
FROM czechia_payroll
WHERE
    value_type_code = 5958 -- průměrná hrubá mzda
;

-- výběr země z tabulky country
SELECT * FROM countries c WHERE country = 'Czech Republic';

SELECT
    payroll_year,
    industry_branch_code,
    ROUND(AVG(value), 2)
FROM czechia_payroll cp
WHERE
    value_type_code = 5958
    AND industry_branch_code = 'B'
GROUP BY payroll_year;

SELECT * FROM czechia_payroll_industry_branch cpib;
-- vytvoření tabulky projektu pro ČR
CREATE TABLE
    IF NOT EXISTS t_martin_kalkus_project_SQL_primary_final();

-- mzdy pro ČR
SELECT *
FROM czechia_payroll cp
    INNER JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code
    CROSS JOIN countries c
WHERE
    value_type_code = 5958
    AND country = 'Czech Republic';

-- potraviny
SELECT *
FROM czechia_price cp
    INNER JOIN czechia_price_category cpc ON cp.category_code = cpc.code
    INNER JOIN czechia_region cr ON cp.region_code = cr.code;
-- kombinace mzdy a potravin
SELECT *
FROM czechia_payroll cp
    INNER JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code
    CROSS JOIN countries c
WHERE
    value_type_code = 5958
    AND country = 'Czech Republic'

UNION ALL

SELECT *
FROM czechia_price cp
    INNER JOIN czechia_price_category cpc ON cp.category_code = cpc.code
    INNER JOIN czechia_region cr ON cp.region_code = cr.code;