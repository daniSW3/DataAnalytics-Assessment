WITH TransactionStats AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        DATEDIFF(MONTH, MIN(s.transaction_date), '2025-05-18') AS tenure_months,
        CASE 
            WHEN DATEDIFF(MONTH, MIN(s.transaction_date), '2025-05-18') = 0 
            THEN COUNT(*) 
            ELSE COUNT(*) * 1.0 / DATEDIFF(MONTH, MIN(s.transaction_date), '2025-05-18') 
        END AS avg_transactions_per_month
    FROM savings_savingsaccount s
    WHERE s.transaction_status = 'success'
    GROUP BY s.owner_id
),
FrequencyCategories AS (
    SELECT 
        CASE 
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_transactions_per_month
    FROM TransactionStats
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM FrequencyCategories
GROUP BY frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;
