/*
 Research question: 4.Is there a year in which the annual increase in food prices was significantly higher than wage growth (more than 10%)?
 */

/*
This code creates a table called t_anual_increse_prices and populates it with data.
The data is calculated based on the average price and average payroll for each product and year from the t_martin_kalkus_project_SQL_primary_final table.
The code calculates the percentage growth of prices and payroll compared to the previous year, as well as the difference between the two growth percentages.
It also includes a compare_indicator column that indicates whether the difference is greater than or equal to 10%.
The final result is sorted by the difference in descending order, followed by the compare_indicator and year.
*/

CREATE TABLE t_anual_increse_prices AS
WITH cte AS (
    SELECT
        `date`,
        product,
        ROUND(AVG(price), 2) AS avg_price,
        ROUND(AVG(payroll), 2) AS avg_payroll
    FROM t_martin_kalkus_project_SQL_primary_final tmkpspf
    GROUP BY `date`, product
)
SELECT
    cte1.`date` AS `year`,
    cte1.product,
    ROUND((((cte1.avg_price / cte2.avg_price) - 1) * 100), 0) AS price_growt_percentage,
    ROUND((((cte1.avg_payroll / cte2.avg_payroll) - 1) * 100), 0) AS payroll_growth_percentage,
    ROUND((((cte1.avg_price / cte2.avg_price) - 1) * 100) - (((cte1.avg_payroll / cte2.avg_payroll) - 1) * 100), 0) AS difference,
    CASE WHEN ROUND((((cte1.avg_price / cte2.avg_price) - 1) * 100) - (((cte1.avg_payroll / cte2.avg_payroll) - 1) * 100), 0) >= 10 THEN '-- more than 10% --'
        ELSE ''
    END AS compare_indicator
FROM cte cte1
JOIN cte cte2
    ON cte1.`date` = cte2.`date` + 1
    AND cte1.product = cte2.product
ORDER BY difference DESC;

-- This code displays table with data for each year. Compare indicator column indicates whether the difference is greater than 10%.
SELECT *
FROM t_anual_increse_prices taip
ORDER BY compare_indicator DESC , `year` 
;
