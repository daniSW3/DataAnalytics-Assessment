WITH CustomerStats AS (
    SELECT 
        u.id AS customer_id,
        u.name,
        DATEDIFF(MONTH, u.date_joined, '2025-05-18') AS tenure_months,
        COUNT(s.id) AS total_transactions,
        COALESCE(SUM(s.confirmed_amount) / 100.0, 0) AS total_transaction_value_ngn
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id 
        AND s.transaction_status = 'success'
    GROUP BY u.id, u.name, u.date_joined
),
CLVCalculation AS (
    SELECT 
        customer_id,
        name,
        tenure_months,
        total_transactions,
        CASE 
            WHEN tenure_months = 0 THEN 0
            ELSE (total_transactions * 1.0 / tenure_months) * 12 * 
                 (total_transaction_value_ngn * 0.001 / NULLIF(total_transactions, 0))
        END AS estimated_clv
    FROM CustomerStats
)
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(estimated_clv, 2) AS estimated_clv
FROM CLVCalculation
WHERE tenure_months > 0
ORDER BY estimated_clv DESC;select * from db.table4
