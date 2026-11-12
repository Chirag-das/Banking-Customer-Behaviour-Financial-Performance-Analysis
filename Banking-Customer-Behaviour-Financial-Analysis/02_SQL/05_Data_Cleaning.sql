
/*============================================================
  PROJECT: Banking Customer Behaviour & Financial Performance
  SCRIPT: 05 - Data Cleaning
  DATABASE: Banking_Analytics
============================================================*/

USE Banking_Analytics;
GO

-- Prevent accidental overwriting of existing clean tables
IF OBJECT_ID('dbo.Bank_Clean', 'U') IS NOT NULL
   OR OBJECT_ID('dbo.Customer_Clean', 'U') IS NOT NULL
   OR OBJECT_ID('dbo.Transactions_Clean', 'U') IS NOT NULL
BEGIN
    THROW 50001,
    'Clean tables already exist. Check before running again.',
    1;
END;
GO

-- 1. Clean Bank table
SELECT
    CAST(Branch_ID AS BIGINT) AS Branch_ID,
    NULLIF(LTRIM(RTRIM(City)), '') AS City,
    NULLIF(LTRIM(RTRIM(Region)), '') AS Region,
    Firm_Revenue,
    Expenses,
    Profit_Margin
INTO dbo.Bank_Clean
FROM dbo.Bank;
GO

-- 2. Clean Customer table
SELECT
    Customer_ID,
    Age,
    NULLIF(LTRIM(RTRIM(Customer_Type)), '') AS Customer_Type,
    NULLIF(LTRIM(RTRIM(City)), '') AS City,
    NULLIF(LTRIM(RTRIM(Region)), '') AS Region,
    NULLIF(LTRIM(RTRIM(Bank_Name)), '') AS Bank_Name,
    Branch_ID
INTO dbo.Customer_Clean
FROM dbo.Customer;
GO

-- 3. Clean Transactions table
SELECT
    Transaction_ID,
    Customer_ID,
    NULLIF(LTRIM(RTRIM(Account_Type)), '') AS Account_Type,
    Total_Balance,
    Transaction_Amount,
    Investment_Amount,
    NULLIF(LTRIM(RTRIM(Investment_Type)), '') AS Investment_Type,
    Transaction_Date
INTO dbo.Transactions_Clean
FROM dbo.Transactions;
GO

-- 4. Verify cleaned table row counts
SELECT 'Bank_Clean' AS Table_Name, COUNT(*) AS Total_Rows
FROM dbo.Bank_Clean

UNION ALL

SELECT 'Customer_Clean', COUNT(*)
FROM dbo.Customer_Clean

UNION ALL

SELECT 'Transactions_Clean', COUNT(*)
FROM dbo.Transactions_Clean;
GO
