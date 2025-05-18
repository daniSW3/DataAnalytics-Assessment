# DataAnalytics-Assessment
## High-Value Customers with Multiple Products
## Task: Identify customers with at least one funded savings plan (is_regular_savings = 1) and one funded investment plan (is_a_fund = 1), sorted by total deposits.

## Approach:

### Join users_customuser with plans_plan to identify plans by owner_id.
### Filter for savings plans (is_regular_savings = 1) and investment plans (is_a_fund = 1) with non-zero funding (amount > 0 in plans_plan or linked confirmed_amount > 0 in savings_savingsaccount).
### Use savings_savingsaccount to calculate total deposits (confirmed_amount for successful transactions).
### Group by owner_id and name, counting distinct savings and investment plans.
### Ensure customers have at least one of each plan type.
### Sort by total deposits (converted from kobo to NGN).
