WITH total AS (
    SELECT COUNT(DISTINCT device_id) AS total_users
    FROM таблица1
),
activity AS (
    SELECT
        device_id,
        DATE(session_time) - DATE('2019-03-01') AS day_number
    FROM таблица1
    WHERE DATE(session_time) - DATE('2019-03-01') BETWEEN 0 AND 7
)
SELECT
    day_number,
    COUNT(DISTINCT device_id) AS retained_users,
    ROUND(100.0 * COUNT(DISTINCT device_id) / (SELECT total_users FROM total), 2) AS retention_per
FROM activity
GROUP BY day_number
ORDER BY day_number;
