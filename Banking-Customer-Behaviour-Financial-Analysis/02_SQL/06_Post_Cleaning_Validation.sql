
/*============================================================
  PROJECT: Banking Customer Behaviour & Financial Performance
  SCRIPT: 06 - Post Cleaning Validation
  DATABASE: Banking_Analytics
============================================================*/

USE Banking_Analytics;
GO

-- 1. Compare original and cleaned row counts

SELECT
    'Bank' AS Dataset,
    (SELECT COUNT(*) FROM dbo.Bank) AS Original_Rows,
    (SELECT COUNT(*) FROM dbo.Bank_Clean) AS Cleaned_Rows

UNION ALL

SELECT
    'Customer',
    (SELECT COUNT(*) FROM dbo.Customer),
    (SELECT COUNT(*) FROM dbo.Customer_Clean)

UNION ALL

SELECT
    'Transactions',
    (SELECT COUNT(*) FROM dbo.Transactions),
    (SELECT COUNT(*) FROM dbo.Transactions_Clean);
GO

-- 2. Check missing values after cleaning

SELECT
    'Bank_Clean' AS Table_Name,
    SUM(CASE WHEN Firm_Revenue IS NULL THEN 1 ELSE 0 END)
        AS Missing_Firm_Revenue
FROM dbo.Bank_Clean

UNION ALL

SELECT
    'Customer_Clean',
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END)
FROM dbo.Customer_Clean

UNION ALL

SELECT
    'Transactions_Clean',
    SUM(CASE WHEN Transaction_Date IS NULL THEN 1 ELSE 0 END)
FROM dbo.Transactions_Clean;
GO

-- 3. Check duplicate IDs

SELECT Branch_ID, COUNT(*) AS Duplicate_Count
FROM dbo.Bank_Clean
GROUP BY Branch_ID
HAVING COUNT(*) > 1;
GO

SELECT Customer_ID, COUNT(*) AS Duplicate_Count
FROM dbo.Customer_Clean
GROUP BY Customer_ID
HAVING COUNT(*) > 1;
GO

SELECT Transaction_ID, COUNT(*) AS Duplicate_Count
FROM dbo.Transactions_Clean
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;
GO

-- 4. Check customer-to-branch relationships

SELECT c.Customer_ID, c.Branch_ID
FROM dbo.Customer_Clean c
LEFT JOIN dbo.Bank_Clean b
    ON c.Branch_ID = b.Branch_ID
WHERE b.Branch_ID IS NULL;
GO

-- 5. Check transaction-to-customer relationships

SELECT t.Transaction_ID, t.Customer_ID
FROM dbo.Transactions_Clean t
LEFT JOIN dbo.Customer_Clean c
    ON t.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;
GO

-- 6. Verify data types of cleaned tables

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME IN
      ('Bank_Clean', 'Customer_Clean', 'Transactions_Clean')
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO
