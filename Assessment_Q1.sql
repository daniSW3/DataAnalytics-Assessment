WITH FundedPlans AS (
    SELECT 
        p.owner_id,
        u.name,
        SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) AS savings_count,
        SUM(CASE WHEN p.is_a_fund = 1 THEN 1 ELSE 0 END) AS investment_count,
        COALESCE(SUM(s.confirmed_amount) / 100.0, 0) AS total_deposits
    FROM plans_plan p
    JOIN users_customuser u ON p.owner_id = u.id
    LEFT JOIN savings_savingsaccount s ON p.id = s.plan_id 
        AND s.transaction_status = 'success' 
        AND s.confirmed_amount > 0
    WHERE p.amount > 0 
        AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
    GROUP BY p.owner_id, u.name
    HAVING 
        SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) > 0 
        AND SUM(CASE WHEN p.is_a_fund = 1 THEN 1 ELSE 0 END) > 0
)
SELECT 
    owner_id,
    name,
    savings_count,
    investment_count,
    total_deposits
FROM FundedPlans
ORDER BY total_deposits DESC;
