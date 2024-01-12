/*
 Research question: 3.Which food category is getting more expensive the slowest (i.e., it has the lowest annual  percentage increase)? 
 */

/*
    This code creates a view called v_food_dif_per_year that calculates the percentage difference in price for each product between consecutive dates.
    The view is created by joining the filtered_data CTE (Common Table Expression) with itself, where each row represents a specific date and product.
    The percentage difference in price is calculated using the formula: ((current_price / previous_price) - 1) * 100.
    The result is rounded to 2 decimal places.
    The final result is ordered by the difference in percentage and date in ascending order.
    The selection statement retrieves the product and difference in percentage from the view v_food_dif_per_year and orders them by the difference in percentage in descending order.
*/
CREATE OR REPLACE VIEW v_food_dif_per_year AS
WITH filtered_data AS (
    SELECT
        `date`,
        product,
        ROUND(AVG(price), 2) AS price
    FROM
        t_martin_kalkus_project_SQL_primary_final tmkpspf
    GROUP BY `date`, product
    ORDER BY date DESC
)
SELECT
    fd.`date` AS `date`,
    fd2.`date` AS prev_date,
    fd.product,
    ROUND(((fd.price / fd2.price) - 1) * 100, 2) AS diff_in_percent
FROM
    filtered_data fd
JOIN
    filtered_data fd2 ON fd.`date` = fd2.`date` + 1 AND fd.product = fd2.product
GROUP BY
    fd.product,
    fd.`date`,
    fd2.`date`
ORDER BY
    diff_in_percent,
    `date`;

SELECT
    product,
    diff_in_percent
FROM
    v_food_dif_per_year vfdpy
ORDER BY
    diff_in_percent DESC;
