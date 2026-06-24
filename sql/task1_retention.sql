-- =============================================
-- Задача: 7-дневный Retention Rate
-- Датасет: data/retention_cohort.csv
-- Таблица: sessions (device_id, session_time)
-- Когорта: пользователи с датой инсталла 1 марта 2019
-- =============================================

WITH total AS (
    SELECT COUNT(DISTINCT device_id) AS total_users
    FROM sessions
),
activity AS (
    SELECT
        device_id,
        DATE(session_time) - DATE('2019-03-01') AS day_number
    FROM sessions
    WHERE DATE(session_time) - DATE('2019-03-01') BETWEEN 0 AND 7
)
SELECT
    day_number,
    COUNT(DISTINCT device_id) AS retained_users,
    ROUND(100.0 * COUNT(DISTINCT device_id) / (SELECT total_users FROM total), 2) AS retention_pct
FROM activity
GROUP BY day_number
ORDER BY day_number;
