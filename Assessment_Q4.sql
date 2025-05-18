USE `adashi_staging`;
WITH transaction_summary AS (
    --   this CTE to summarizethe  total transactions and also the average transaction value for each customer
    SELECT
        sa.owner_id AS customer_id,
        COUNT(*) AS total_transactions,
        AVG(sa.amount) AS avg_transaction_value
    FROM savings_savingsaccount sa
    GROUP BY sa.owner_id
),
user_tenure AS (
    -- this CTE to get the tenure of customer in month
    SELECT
        u.id AS customer_id,
        concat(u.first_name, ' ', u.last_name) as name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months
    FROM users_customuser u
)
-- below main query then select the customerid, name, tenuremonth, total transaction and the Estimated_CLv
SELECT
    ut.customer_id,
    ut.name,
    ut.tenure_months,
    COALESCE(ts.total_transactions, 0) AS total_transactions,  -- this to have 0 for Customer with no transaction instead of having nulls
    --  below case statement calculates Estimated CLV for those with atleast a month tenure and return 0 for those not up to a month
    CASE
        WHEN ut.tenure_months > 0 
        THEN (COALESCE(ts.total_transactions, 0) / ut.tenure_months) * 12 * (COALESCE(ts.avg_transaction_value, 0) * 0.001)
        ELSE 0  
    END AS estimated_clv
FROM user_tenure ut
LEFT JOIN transaction_summary ts ON ut.customer_id = ts.customer_id
ORDER BY estimated_clv DESC;
