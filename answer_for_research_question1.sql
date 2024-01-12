/*
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