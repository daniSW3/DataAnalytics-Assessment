# DataAnalytics-Assessment
## 1 High-Value Customers with Multiple Products
### Task: Identify customers with at least one funded savings plan (is_regular_savings = 1) and one funded investment plan (is_a_fund = 1), sorted by total deposits.

### Approach:

### Join users_customuser with plans_plan to identify plans by owner_id.
### Filter for savings plans (is_regular_savings = 1) and investment plans (is_a_fund = 1) with non-zero funding (amount > 0 in plans_plan or linked confirmed_amount > 0 in savings_savingsaccount).
### Use savings_savingsaccount to calculate total deposits (confirmed_amount for successful transactions).
### Group by owner_id and name, counting distinct savings and investment plans.
### Ensure customers have at least one of each plan type.
### Sort by total deposits (converted from kobo to NGN).

## 2 Transaction Frequency Analysis
### Task: Calculate the average number of transactions per customer per month and categorize them into:
### High Frequency (≥10 transactions/month)
### Medium Frequency (3-9 transactions/month)
### Low Frequency (≤2 transactions/month)
### Approach:

### Use savings_savingsaccount to count transactions (transaction_status = 'success') per owner_id.
### Join with users_customuser to include all customers.
### Calculate the tenure (months) from the earliest transaction date to the current date (May 18, 2025).
### Compute average transactions per month (total_transactions / tenure_months).
### Categorize based on the thresholds.
### Group by frequency category and count customers.

## 3 Account Inactivity Alert
### Task: Find active accounts (savings or investment plans) with no inflow transactions in the last 365 days (from May 18, 2025).

### Approach:

### Identify active plans from plans_plan (is_deleted = 0 and is_archived = 0).
### Use savings_savingsaccount to find the latest successful transaction (transaction_status = 'success') per plan_id.
### Filter for plans with no transactions since May 18, 2024 (365 days prior).
### Include plan type (“Savings” for is_regular_savings = 1, “Investment” for `is_a_fund = 1”).
### Calculate inactivity days using DATEDIFF.

## 4 Customer Lifetime Value (CLV) Estimation
### Task: Estimate CLV for each customer based on:
### Account tenure (months since date_joined).
### Total transactions (successful transactions in savings_savingsaccount).
### CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction, where profit is 0.1% of transaction value.
### Approach:

### Join users_customuser with savings_savingsaccount to get transaction data.
### Count successful transactions and sum confirmed_amount for profit calculation.
### Calculate tenure from date_joined to May 18, 2025.
### Compute average profit per transaction (0.1% of confirmed_amount in kobo, converted to NGN).
### Calculate CLV using the formula.
### Order by CLV descending.
