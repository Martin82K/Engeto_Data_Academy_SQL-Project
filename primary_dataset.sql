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

/*
 This selection query retrieves data from multiple tables to generate a report on payroll information.
 The query filters the data from the 'czechia_payroll' table based on the 'value_type_code' column.
 It then joins the filtered data with other tables to retrieve additional information such as industry, payroll, product details, price, quantity, and unit.
 The final result set includes columns for date, industry, payroll, product_id, product, price, quantity, and unit.
 */
CREATE TABLE
    IF NOT EXISTS t_martin_kalkus_project_SQL_primary_final
WITH
    czechia_payroll_selection AS (
        SELECT *
        FROM czechia_payroll
        WHERE
            value_type_code = '5958'
    )
SELECT
    date_format(cpr.date_from, '%X') AS `date`,
    cpib.name AS industry,
    cps.value AS payroll,
    cpr.id AS product_id,
    cpc.name AS product,
    cpr.value AS price,
    cpc.price_value AS quantity,
    cpc.price_unit AS unit
FROM
    czechia_payroll_selection cps
    LEFT JOIN czechia_payroll_industry_branch cpib ON cps.industry_branch_code = cpib.code
    LEFT JOIN czechia_price cpr ON date_format(cpr.date_from, '%X') = date_format(
        makedate(cps.payroll_year, 365),
        '%X'
    )
    LEFT JOIN czechia_price_category cpc ON cpr.category_code = cpc.code;

* /
/*
 * 
 Research question: 1. Are wages increasing over the years in all industries, or are they decreasing in some?
 */
/*
 This code creates or replaces a view called v_payroll_dev.
 The view calculates the average payroll for each industry and year, comparing it to the previous year's average payroll.
 The result includes the year, previous year, industry, current payroll, previous payroll, and the development trend (increasing or decreasing).
 The calculation is based on the table t_martin_kalkus_project_SQL_primary_final.
 */
CREATE
OR
REPLACE VIEW v_payroll_dev AS
WITH selected_data AS (
        SELECT
            `date`,
            industry,
            ROUND(AVG(payroll), 0) AS avg_payroll
        FROM
            t_martin_kalkus_project_SQL_primary_final tmkpspf
        GROUP BY
            industry,
            `date`
    )
SELECT
    sd.`date` AS `year`,
    sd2.`date` AS year_prev,
    sd.industry AS industry,
    sd.avg_payroll AS payroll_current,
    sd2.avg_payroll AS payroll_prev,
    CASE
        WHEN (
            sd.avg_payroll > sd2.avg_payroll
        ) THEN 'Increasing'
        ELSE 'Decreasing'
    END AS payroll_develop
FROM selected_data sd
    JOIN selected_data sd2 ON sd.`date` = sd2.`date` + 1 AND sd.industry = sd2.industry;

SELECT *
FROM v_payroll_dev
WHERE
    payroll_develop = 'Decreasing'
ORDER BY `year`;

/*
 * VÝZKUMNÁ OTÁZKA: 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
 */