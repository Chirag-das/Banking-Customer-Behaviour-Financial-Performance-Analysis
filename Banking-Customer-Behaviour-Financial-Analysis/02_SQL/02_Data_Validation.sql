
/*============================================================
  PROJECT: Banking Customer Behaviour & Financial Performance
  SCRIPT: 02 - Data Validation
============================================================*/

USE Banking_Analytics;
GO

-- 1. Confirm that all three tables exist
SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_NAME IN ('Bank', 'Customer', 'Transactions')
ORDER BY TABLE_NAME;
GO

-- 2. Check row counts
SELECT 'Bank' AS Dataset, COUNT_BIG(*) AS Total_Rows
FROM dbo.Bank

UNION ALL

SELECT 'Customer', COUNT_BIG(*)
FROM dbo.Customer

UNION ALL

SELECT 'Transaction', COUNT_BIG(*)
FROM dbo.Transactions;
GO

-- 3. Inspect column names and data types
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME IN ('Bank', 'Customer', 'Transactions')
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO

-- 4. Preview imported records
SELECT TOP 10 * FROM dbo.Bank;
SELECT TOP 10 * FROM dbo.Customer;
SELECT TOP 10 * FROM dbo.Transactions;
GO
