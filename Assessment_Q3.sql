USE `adashi_staging`;
WITH last_transaction AS (
	-- this CTE will getthe  most recent transaction date for each plan_id
    SELECT 
        sa.plan_id,
        MAX(sa.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount sa
    GROUP BY sa.plan_id
)
-- this main query select statement select the plan_id,  the type, last transactopn date and the number of in active day 
SELECT 
    p.id AS plan_id,
    p.owner_id, 
    -- The case statement below assigns  the type if it is its saving or investment
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
    END AS type,
    lt.last_transaction_date,
    DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days
FROM plans_plan p
LEFT JOIN last_transaction lt ON p.id = lt.plan_id
WHERE 
    p.is_deleted = 0  -- i use this to get only active accounts, I used  is_deleted because it iis unclear what status_id means, status_id has values 1 and 2, but is_deleted is True when plan is not active and 0 when active 
    AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)  -- this filter  will make it to  only includesavings and investment plans
    AND lt.last_transaction_date < DATE_SUB(CURDATE(), INTERVAL 365 DAY) 
ORDER BY inactivity_days DESC;
