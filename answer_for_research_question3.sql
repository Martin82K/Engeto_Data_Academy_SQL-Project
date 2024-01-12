/*
 Research question: 3.Which food category is getting more expensive the slowest (i.e., it has the lowest annual  percentage increase)? 
 */

CREATE
OR
REPLACE
    VIEW v_food_dif_per_year AS
WITH filtered_data AS(
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
    ROUND( ( ( (fd.price / fd2.price) -1) * 100),
        2
    ) AS diff_in_percent
FROM filtered_data fd
    JOIN filtered_data fd2 ON fd.`date` = fd2.`date` + 1 AND fd.product = fd2.product
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
ORDER BY diff_in_percent DESC;