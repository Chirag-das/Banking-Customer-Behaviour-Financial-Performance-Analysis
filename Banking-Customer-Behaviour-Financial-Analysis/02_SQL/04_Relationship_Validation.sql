
/*============================================================
  PROJECT: Banking Customer Behaviour & Financial Performance
  SCRIPT: 04 - Relationship Validation
============================================================*/

USE Banking_Analytics;
GO

-- 1. Customers without a matching bank branch
SELECT
    c.Customer_ID,
    c.Branch_ID
FROM dbo.Customer c
LEFT JOIN dbo.Bank b
    ON c.Branch_ID = b.Branch_ID
WHERE b.Branch_ID IS NULL;
GO

-- 2. Transactions without a matching customer
SELECT
    t.Transaction_ID,
    t.Customer_ID
FROM dbo.Transactions t
LEFT JOIN dbo.Customer c
    ON t.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;
GO

-- 3. Check whether all branch IDs are unique
SELECT
    Branch_ID,
    COUNT(*) AS Record_Count
FROM dbo.Bank
GROUP BY Branch_ID
HAVING COUNT(*) > 1;
GO

-- 4. Check whether all customer IDs are unique
SELECT
    Customer_ID,
    COUNT(*) AS Record_Count
FROM dbo.Customer
GROUP BY Customer_ID
HAVING COUNT(*) > 1;
GO
