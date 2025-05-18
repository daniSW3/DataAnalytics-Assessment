WITH LastTransaction AS (
    SELECT 
        s.plan_id,
        MAX(s.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount s
    WHERE s.transaction_status = 'success'
    GROUP BY s.plan_id
)
SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
    END AS type,
    lt.last_transaction_date,
    DATEDIFF(DAY, lt.last_transaction_date, '2025-05-18') AS inactivity_days
FROM plans_plan p
LEFT JOIN LastTransaction lt ON p.id = lt.plan_id
WHERE 
    p.is_deleted = 0 
    AND p.is_archived = 0
    AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
    AND (lt.last_transaction_date IS NULL OR lt.last_transaction_date < DATEADD(DAY, -365, '2025-05-18'))
ORDER BY inactivity_days DESC;
