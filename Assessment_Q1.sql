
USE `adashi_staging`;

WITH savings_counts AS (
    -- this CTE  get Count of funded savings plans per user (excluding reversals or failed *using confirmed_amount > 0*)
    SELECT
        sa.owner_id,
        COUNT(DISTINCT sa.id) AS savings_count
    FROM savings_savingsaccount sa
    INNER JOIN plans_plan p ON sa.plan_id = p.id
    WHERE p.is_regular_savings = 1
      AND sa.confirmed_amount > 0
    GROUP BY sa.owner_id
),

investment_counts AS (
    -- this CTE  gets the  Count of funded investment plans by each user excluding reversals or failed 
    SELECT
        sa.owner_id,
        COUNT(DISTINCT sa.id) AS investment_count
    FROM savings_savingsaccount sa
    INNER JOIN plans_plan p ON sa.plan_id = p.id
    WHERE p.is_a_fund = 1
      AND sa.confirmed_amount > 0
    GROUP BY sa.owner_id
),

total_deposits AS (
    -- Total confirmed deposits per user
    SELECT
        sa.owner_id,
        SUM(sa.confirmed_amount) AS total_deposits
    FROM savings_savingsaccount sa
    GROUP BY sa.owner_id
)
-- This main query below then gets the owner, name, count of saving, count of investment and the total deposit
SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COALESCE(savings_counts.savings_count, 0) AS savings_count,
    COALESCE(investment_counts.investment_count, 0) AS investment_count,
    COALESCE(total_deposits.total_deposits, 0) AS total_deposits
FROM users_customuser u
LEFT JOIN savings_counts ON u.id = savings_counts.owner_id
LEFT JOIN investment_counts ON u.id = investment_counts.owner_id
LEFT JOIN total_deposits ON u.id = total_deposits.owner_id
WHERE 
    savings_counts.savings_count > 0 -- To only include those with atleast 1 savings
    AND investment_counts.investment_count > 0 -- To only include those with atleast 1 investment transaction
ORDER BY total_deposits DESC;
