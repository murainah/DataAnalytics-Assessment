USE `adashi_staging`;
WITH monthly_Transaction_counts AS ( -- this CTE Calculate and get monthly transaction counts per user
    SELECT
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS Transaction_month,
        COUNT(*) AS Transaction_count
    FROM savings_savingsaccount
    GROUP BY owner_id, Transaction_month
),
avg_transaction_per_customer AS ( --  this CTE will  get the average counts of transaction  by each costumer
    SELECT
        owner_id,
        AVG(Transaction_count) AS avg_transactions_per_month
    FROM monthly_Transaction_counts
    GROUP BY owner_id
)
 -- this main query below  select and  Categorize users by the frequency and count how many falls in each category
SELECT 
	-- The case statement assigns  Frequency Category
    CASE
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS Average_Transactions_Per_Month
FROM avg_transaction_per_customer
GROUP BY frequency_category
--  Ordering clause below for the output to be ordered from high to low arcondinly
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency'); 
