WITH churned_customers AS (
	SELECT 
		COUNT(customer_id) AS churned,
		FORMAT(subscription_end, 'yyyy-MM') AS churn_month
	FROM subscriptions
	WHERE subscription_end IS NOT NULL
	GROUP BY FORMAT(subscription_end, 'yyyy-MM')
),
total_Customers AS (
	SELECT 
		COUNT(DISTINCT(customer_id)) AS total,
		FORMAT(subscription_start, 'yyyy-MM') AS start_month
	FROM subscriptions
	GROUP BY FORMAT(subscription_start, 'yyyy-MM')
)

SELECT  c.churn_month,
		c.churned,
		t.total,
		(c.churned*100/t.total) AS churn_rate
FROM	churned_customers c
JOIN	total_customers t
ON		c.churn_month = t.start_month
ORDER BY churn_rate DESC

