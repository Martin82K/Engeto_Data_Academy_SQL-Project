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
 * Příprava tabulky dat.
 * Vzhledem k tomu, že spojované tabulky obsahují data pro ČR, nebylo nutné připojovat další tabulku s údaji o zemi.
 * Vytvoříme tabulku s názvem t_martin_kalkus_project_SQL_primary_final.
 * Výsledná tabulka obsahuje data z tabulek czechia_payroll a czechia_payroll_industry_branch, obsahující data o mzdách.
 * Dále připojíme data z tabulek czechia_price, czechia_price_category a czechia_region, obsahující data o potravinách.
 * Výsledná tabulka obsahuje data pro ČR, která jsou potřebná pro zodpovězení výzkumných otázek.
 */

-- vytvoření tabulky projektu pro ČR
CREATE TABLE
    t_martin_kalkus_project_SQL_primary_final AS
SELECT *
FROM czechia_payroll cp
    INNER JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code
WHERE value_type_code = 5958
UNION ALL
-- připojení dat pro potraviny
SELECT *
FROM czechia_price cp
    INNER JOIN czechia_price_category cpc ON cp.category_code = cpc.code
    INNER JOIN czechia_region cr ON cp.region_code = cr.code;

/*
 * Výzkumná otázka: 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 *
 * Z tabhulky t_martin_kalkus_project_SQL_primary_final vybereme názvy odvětví a roky, za které máme data. 
 * Následně vytvoříme tabulku (CTE) s názvem prumerny_plat, která obsahuje průměrné mzdy za jednotlivá odvětví a roky. 
 * Aplikujeme funkci Lead, která nám umožní porovnat průměrné mzdy v jednotlivých letech. 
 * Výsledná tabulka obsahuje mimo původní sloupce také status s vyznačením roku s posledním růstem mezd.
 */

-- TEMP CTE a následná podmínka
WITH prumerny_plat AS (
        SELECT
            name AS industry_category,
            payroll_year AS year,
            ROUND(AVG(value), 0) AS salary_avg
        FROM
            t_martin_kalkus_project_SQL_primary_final
        GROUP BY
            name,
            payroll_year
    )
SELECT
    pp.*,
    CASE
        WHEN pp.salary_avg > LEAD(pp.salary_avg) OVER (
            PARTITION BY pp.industry_category
            ORDER BY
                pp.year
        ) THEN 'Konec růstu'
        ELSE ''
    END AS status
FROM prumerny_plat pp;

/*
 * VÝZKUMNÁ OTÁZKA: 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
 */