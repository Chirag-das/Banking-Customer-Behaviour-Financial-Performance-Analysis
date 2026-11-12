
/*============================================================
  PROJECT: Banking Customer Behaviour & Financial Performance
  SCRIPT: 03 - Data Quality Checks
============================================================*/

USE Banking_Analytics;
GO

-- 1. BANK: Missing values
SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Branch_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Branch_ID,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS Missing_City,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS Missing_Region,
    SUM(CASE WHEN Firm_Revenue IS NULL THEN 1 ELSE 0 END) AS Missing_Firm_Revenue,
    SUM(CASE WHEN Expenses IS NULL THEN 1 ELSE 0 END) AS Missing_Expenses,
    SUM(CASE WHEN Profit_Margin IS NULL THEN 1 ELSE 0 END) AS Missing_Profit_Margin
FROM dbo.Bank;
GO

-- 2. CUSTOMER: Missing values
SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Customer_ID,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Missing_Age,
    SUM(CASE WHEN Customer_Type IS NULL THEN 1 ELSE 0 END) AS Missing_Customer_Type,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS Missing_City,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS Missing_Region,
    SUM(CASE WHEN Bank_Name IS NULL THEN 1 ELSE 0 END) AS Missing_Bank_Name,
    SUM(CASE WHEN Branch_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Branch_ID
FROM dbo.Customer;
GO

-- 3. TRANSACTION: Missing values
SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Transaction_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Transaction_ID,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Customer_ID,
    SUM(CASE WHEN Account_Type IS NULL THEN 1 ELSE 0 END) AS Missing_Account_Type,
    SUM(CASE WHEN Total_Balance IS NULL THEN 1 ELSE 0 END) AS Missing_Total_Balance,
    SUM(CASE WHEN Transaction_Amount IS NULL THEN 1 ELSE 0 END) AS Missing_Transaction_Amount,
    SUM(CASE WHEN Investment_Amount IS NULL THEN 1 ELSE 0 END) AS Missing_Investment_Amount,
    SUM(CASE WHEN Investment_Type IS NULL THEN 1 ELSE 0 END) AS Missing_Investment_Type,
    SUM(CASE WHEN Transaction_Date IS NULL THEN 1 ELSE 0 END) AS Missing_Transaction_Date
FROM dbo.Transactions;
GO

-- 4. Duplicate Bank branch IDs
SELECT Branch_ID, COUNT(*) AS Duplicate_Count
FROM dbo.Bank
GROUP BY Branch_ID
HAVING COUNT(*) > 1;
GO

-- 5. Duplicate Customer IDs
SELECT Customer_ID, COUNT(*) AS Duplicate_Count
FROM dbo.Customer
GROUP BY Customer_ID
HAVING COUNT(*) > 1;
GO

-- 6. Duplicate Transaction IDs
SELECT Transaction_ID, COUNT(*) AS Duplicate_Count
FROM dbo.Transactions
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;
GO

-- 7. Check invalid customer ages
SELECT *
FROM dbo.Customer
WHERE TRY_CONVERT(INT, Age) IS NULL
   OR TRY_CONVERT(INT, Age) < 0
   OR TRY_CONVERT(INT, Age) > 120;
GO

-- 8. Check invalid transaction dates
SELECT *
FROM dbo.Transactions
WHERE TRY_CONVERT(DATE, Transaction_Date) IS NULL;
GO
