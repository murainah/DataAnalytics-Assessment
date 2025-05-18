## Question 1
High-Value Customers with Multiple Products

### My Approach:
I started by counting the number of funded savings and investment plans for each customer. I joined the savings_savingsaccount and plans_plan tables and filtered out any transactions with a confirmed_amount of zero or less, ensuring only successful transactions were included, then I calculated the total confirmed deposits for each customer. I then used LEFT JOINs to attach the savings count, investment count, and total deposits to the users_customuser table.
I filtered the results to include only those with at least one savings plan and one investment plan.  I then sorted the customers in descending order of their total deposited amount to highlight the highest contributors.

### Challenges I Faced:
I noticed that some transactions were being included which maybe  reversals or failed attempts, because they have -ve or 0 in confirmed_amount, I used filter confirmed_amount > 0, which  exclude any of those transactions.



## Question 2
Transaction Frequency Analysis

### My Approach:
I calculated monthly transaction counts per customer by months and then I computed the average transactions per month for each customer. based on these averages I categorized customers into three groups (High Frequency, Medium Frequency, and Low Frequency).  I then finally aggregated the number of customers in each category and calculated the average transaction count per group to better understand customer engagement patterns.



## Question 3 
Account Inactivity Alert

### My Approach:
I start with  using CTE to identify the  transaction date that is most recent for each plan. I then joined this with the plans_plan table to get the ownerid and type . I filtered the results to include only active plans (using is_deleted = 0) and limited the output to plans that haven't had any transactions in over a year. I also used a CASE statement to classify the plan type as either Savings or Investment and calculated the inactivity duration in days using the DATEDIFF function.

### Challenges I Faced:
Determining the correct field to identify active plans. While working on identifying active plans, I noticed that the status_id field has values 1 and 2, which are not simply binary flags (like 0 or 1) that clearly indicate No/Yes. Both statuses have recent last transactions on the same day, with Status 2 last transaction: 2025-04-18 14:19:50 and Status 1 last transaction: 2025-04-18 15:03:13
Because the meaning of these status_id values was unclear, I chose to filter active plans using the is_deleted column instead, where 0 clearly indicates active(not delted) plans and 1 indicates deleted plans.


## Question 4
Customer Lifetime Value (CLV) Estimation

### My Approach:
i started by calculating total transactions and average transaction value per customer. then i compute the customer tenure in months since signup. Then, I applied the formula: **CLV = (total_transactions / tenure_months) * 12 * (avg_transaction_value * 0.001)**. I then used COALESCE to replace NULL values with zeros for customers without transactions and added a condition to return 0 for customers whose tenure is less than a month.

###  Challenges I Faced:
challenge i face is handling customers with no transactions, as this resulted in NULL values for transaction counts and averages. I resolved this by using COALESCE to default these to 0.
Another iss avoiding division by zero errors when a customer's tenure was zero. I addressed this by wrapping the CLV formula in a CASE statement to return 0 when tenure_months is 0.
