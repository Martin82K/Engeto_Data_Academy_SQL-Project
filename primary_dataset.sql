/*
 Martin Kalkuš - discord: martink8047 
 */

/*
 Create primary dataset "t_martin_kalkus_project_SQL_primary_final"
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