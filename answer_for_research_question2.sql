/*
 * Research question: 2.How many liters of milk and kilograms of bread can be bought for the first and last comparable period in the available data of prices and wages?
 */

-- This code creates or replaces a view for milk and bread prices in all data.
CREATE
OR
REPLACE
    VIEW v_answer2_filter AS (
        SELECT
            `date`,
            product_id,
            product,
            quantity,
            unit,
            price,
            round(avg(payroll), 0) AS payroll
        FROM
            t_martin_kalkus_project_SQL_primary_final tmkpspf
        WHERE
            product LIKE '%mléko%'
            OR product LIKE '%chléb%'
        GROUP BY
            industry,
            `date`,
            product_id,
            product,
            quantity,
            unit,
            price
    );

-- This code show a power to buy in year 2006 and 2018.
SELECT
    `date`,
    product,
    ROUND(AVG(payroll), 0) AS avg_payroll,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(payroll) / AVG(price), 2) AS units_per_payroll,
    unit
FROM v_answer2_filter vaf
WHERE
    `date` IN ('2006', '2018')
GROUP BY
    `date`,
    product,
    unit;