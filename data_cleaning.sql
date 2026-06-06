SELECT
    order_id,
    COALESCE(user_id, 'unknown')         AS user_id,
    user_name,
    user_email,
    user_city,
    user_country,
    product_id,
    product_name,
    category,
    CAST(price AS FLOAT)                 AS price,
    quantity,
    CAST(price AS FLOAT) * quantity      AS total,
    COALESCE(payment_method, 'unknown')  AS payment_method,
    timestamp
INTO clean_orders
FROM [sales-stream-stream]
WHERE price IS NOT NULL