/*
 Research question: 5. Does the level of GDP affect changes in wages and food prices? In other words, if GDP increases significantly in one year, will this be reflected in food prices or wages in the same or following year with a more significant increase?
 */
 
/*
This code creates a view called v_GDP_price_payroll. 
The view calculates various metrics related to GDP, price growth, and payroll growth for the country 'Czech Republic'. 
It uses multiple CTEs and joins to retrieve the necessary data and perform the calculations. 
The result includes the previous year, current year, and next year, along with the average price growth percentage, average payroll growth percentage, and GDP deviation. 
Based on these metrics, it determines the relationship between GDP growth and price growth as well as GDP growth and payroll growth. 
The final result includes a descriptive label for each relationship. 
The view is grouped by years and GDP values.
*/

 CREATE VIEW v_GDP_price_payroll AS
WITH temporary_table AS (
    SELECT `year`, country
    FROM t_martin_kalkus_project_SQL_secondary_final tmkpssf
    WHERE country = 'czech republic'
),
GDP_data AS (
    SELECT `year`, GDP
    FROM t_martin_kalkus_project_SQL_secondary_final tmkpssf
    WHERE country = 'czech republic'
)
SELECT
    tt2.`year` AS year_prev,
    tt.`year` AS `year`,
    taip2.`year` AS year_next,
    ROUND(AVG(taip.price_growt_percentage), 0) AS price_diff,
    ROUND(AVG(taip2.price_growt_percentage), 0) AS price_diff_next,
    ROUND(AVG(taip.payroll_growth_percentage), 0) AS payroll_diff,
    ROUND(AVG(taip2.payroll_growth_percentage), 0) AS payroll_diff_next,
    ROUND(((g1.GDP / g2.GDP) - 1) * 100, 0) AS GDP_dev,
    CASE WHEN ROUND(((g1.GDP / g2.GDP) - 1) * 100, 0) > 0 THEN 
        CASE WHEN ROUND(AVG(taip.price_growt_percentage), 0) >= 5 THEN
            CASE WHEN ROUND(AVG(taip2.price_growt_percentage), 0) >= 5 THEN 'Increase GDP and increase both current and next years price'
                ELSE 'Increase GDP and increase current price but not next years price'
            END
        ELSE CASE WHEN ROUND(AVG(taip2.price_growt_percentage), 0) >= 5 THEN 'Increase GDP and next years price but not current price'
            ELSE 'Increase of GDP but not current or next years price'
            END 
        END 
    ELSE 'Not increasing GDP'
    END AS price_compare,
    CASE WHEN ROUND(((g1.GDP / g2.GDP) - 1) * 100, 0) > 0 THEN 
        CASE WHEN ROUND(AVG(taip.payroll_growth_percentage), 0) >= 5 THEN
            CASE WHEN ROUND(AVG(taip2.payroll_growth_percentage), 0) >= 5 THEN 'Increase GDP and increase both current and next years wages'
                ELSE 'Increase GDP and increase current wages but not next years wages'
            END
        ELSE CASE WHEN ROUND(AVG(taip2.payroll_growth_percentage), 0) >= 5 THEN 'Increase GDP and next years wages but not current wages'
            ELSE 'Increase of GDP but not current or next years wages'
            END 
        END 
    ELSE 'Not increasing GDP'
    END AS payroll_compare
FROM temporary_table tt 
LEFT JOIN temporary_table tt2 ON tt.`year` = tt2.`year` + 1
LEFT JOIN t_anual_increse_prices taip ON tt.`year` = taip.`year`
LEFT JOIN t_anual_increse_prices taip2 ON taip.`year` = taip2.`year` - 1 AND taip.product = taip2.product
LEFT JOIN GDP_data g1 ON tt.`year` = g1.`year`
LEFT JOIN GDP_data g2 ON tt2.`year` = g2.`year`
WHERE
    taip.price_growt_percentage IS NOT NULL
    AND taip2.price_growt_percentage IS NOT NULL
    AND taip.payroll_growth_percentage IS NOT NULL
    AND taip2.payroll_growth_percentage IS NOT NULL
GROUP BY tt.`year`, tt2.`year`, taip2.`year`, g1.GDP, g2.GDP; 
