CREATE VIEW gold_orders AS
SELECT
    order_id,
    user_id,
    product_id,
    category,
    payment_method,
    price,
    quantity,
    total,
    CASE 
        WHEN timestamp LIKE '__/__/____%' 
        THEN CONVERT(DATE, timestamp, 103)
        ELSE TRY_CAST(timestamp AS DATE)
    END                                     AS order_date,
    YEAR(CASE 
        WHEN timestamp LIKE '__/__/____%' 
        THEN CONVERT(DATE, timestamp, 103)
        ELSE TRY_CAST(timestamp AS DATE)
    END)                                    AS order_year,
    MONTH(CASE 
        WHEN timestamp LIKE '__/__/____%' 
        THEN CONVERT(DATE, timestamp, 103)
        ELSE TRY_CAST(timestamp AS DATE)
    END)                                    AS order_month,
    DAY(CASE 
        WHEN timestamp LIKE '__/__/____%' 
        THEN CONVERT(DATE, timestamp, 103)
        ELSE TRY_CAST(timestamp AS DATE)
    END)                                    AS order_day
FROM (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY order_id 
            ORDER BY timestamp DESC
        ) AS rn
    FROM clean_orders
    WHERE timestamp IS NOT NULL
) AS deduped
WHERE rn = 1



CREATE VIEW dim_date AS
SELECT DISTINCT
    CASE 
        WHEN timestamp LIKE '__/__/____%' 
        THEN CONVERT(DATE, timestamp, 103)
        ELSE TRY_CAST(timestamp AS DATE)
    END                                     AS order_date,
    YEAR(CASE 
        WHEN timestamp LIKE '__/__/____%' 
        THEN CONVERT(DATE, timestamp, 103)
        ELSE TRY_CAST(timestamp AS DATE)
    END)                                    AS order_year,
    MONTH(CASE 
        WHEN timestamp LIKE '__/__/____%' 
        THEN CONVERT(DATE, timestamp, 103)
        ELSE TRY_CAST(timestamp AS DATE)
    END)                                    AS order_month,
    DAY(CASE 
        WHEN timestamp LIKE '__/__/____%' 
        THEN CONVERT(DATE, timestamp, 103)
        ELSE TRY_CAST(timestamp AS DATE)
    END)                                    AS order_day
FROM clean_orders
WHERE timestamp IS NOT NULL



CREATE VIEW dim_products AS
SELECT DISTINCT
    product_id,
    product_name,
    category
FROM clean_orders




CREATE VIEW dim_users AS
SELECT DISTINCT
    user_id,
    user_name,
    user_email,
    user_city,
    user_country
FROM clean_orders