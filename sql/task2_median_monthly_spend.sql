WITH regular_clients AS (
    SELECT CARD_NUMBER
    FROM COFFEE_SALES
    GROUP BY CARD_NUMBER
    HAVING COUNT(DISTINCT DATE_TRUNC('month', SALE_DTTM)) > 1
),
monthly_spend AS (
    SELECT
        cs.CARD_NUMBER,
        DATE_TRUNC('month', cs.SALE_DTTM) AS month,
        SUM(cs.PRICE * (1 - cs.DISCOUNT / 100.0)) AS total_spend
    FROM COFFEE_SALES cs
    JOIN regular_clients rc ON cs.CARD_NUMBER = rc.CARD_NUMBER
    GROUP BY cs.CARD_NUMBER, DATE_TRUNC('month', cs.SALE_DTTM)
),
ranked AS (
    SELECT
        month,
        total_spend,
        ROW_NUMBER() OVER (PARTITION BY month ORDER BY total_spend) AS rn,
        COUNT(*)     OVER (PARTITION BY month) AS podschet
    FROM monthly_spend
)
SELECT
    month,
    AVG(total_spend) AS median_spend
FROM ranked
WHERE rn IN (FLOOR((podschet + 1) / 2.0), CEIL((podschet + 1) / 2.0))
GROUP BY month
ORDER BY month;
