
SELECT revenue
FROM SampleData_MarketingAnalytics

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SampleData_MarketingAnalytics'
AND COLUMN_NAME = 'revenue'

SELECT revenue
FROM SampleData_MarketingAnalytics
WHERE ISNUMERIC(revenue) = 0
AND revenue	IS NOT NULL

SELECT revenue
FROM SampleData_MarketingAnalytics
WHERE TRY_CONVERT(FLOAT, revenue) IS NULL
AND revenue IS NOT NULL;

ALTER TABLE SampleData_MarketingAnalytics
ALTER COLUMN revenue FLOAT;

SELECT SUM(TRY_CONVERT(FLOAT, revenue)) AS total_sum
FROM SampleData_MarketingAnalytics


-- 1️⃣ Count the number of users at each stage of the funnel
SELECT event_type, COUNT(DISTINCT user_id) AS user_count
FROM SampleData_MarketingAnalytics
GROUP BY event_type;

-- 2️⃣ Calculate the conversion rate at each stage of the funnel
WITH funnel AS (
    SELECT 
        COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_id END) AS views,
        COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS add_to_cart,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchases
    FROM SampleData_MarketingAnalytics
)
SELECT 
    (add_to_cart * 100.0 / views) AS add_to_cart_conversion_rate,
    (purchases * 100.0 / add_to_cart) AS purchase_conversion_rate,
    (purchases * 100.0 / views) AS overall_conversion_rate
FROM funnel;

-- 3️⃣ Total revenue generated from purchases
SELECT SUM(TRY_CONVERT(FLOAT,revenue)) AS total_revenue
FROM SampleData_MarketingAnalytics
WHERE event_type = 'purchase';

-- 4️⃣ Find the most purchased product
SELECT product_id, COUNT(*) AS purchase_count
FROM SampleData_MarketingAnalytics
WHERE event_type = 'purchase'
GROUP BY product_id
ORDER BY purchase_count DESC;