WITH last_purchase AS (
	SELECT customer_id, MAX(order_date) AS last_order_date
	FROM Customer_Transactions
	GROUP BY customer_id
),
churned_customer AS(
	SELECT c.customer_id, c.last_order_date,
		CASE
			WHEN SUM(t.order_value) > 2000 THEN 'High_Value_Churn'
			WHEN SUM(t.order_value) BETWEEN 1000 AND 2000 THEN 'Medium_Value_Churn'
			ELSE 'Low_Value_Churn'
		END AS churn_segment
	FROM last_purchase c
	JOIN Customer_Transactions t ON c.customer_id = t.customer_id
	WHERE c.last_order_date < DATEADD(Month, -2, GETDATE())  -- No purchase in last two months
	GROUP BY c.customer_id, c.last_order_date
)
SELECT * FROM churned_customer
ORDER BY last_order_date ASC;