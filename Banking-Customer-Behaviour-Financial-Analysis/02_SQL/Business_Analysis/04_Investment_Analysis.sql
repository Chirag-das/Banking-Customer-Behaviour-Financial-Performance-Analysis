
USE Banking_Analytics;
GO

/*====================================================
  INVESTMENT ANALYSIS
  Project: Banking Customer Behaviour &
           Financial Performance Analysis
====================================================*/


/* 1. OVERALL INVESTMENT OVERVIEW */

SELECT
    COUNT(*) AS Total_Transaction_Records,
    COUNT(Investment_Amount) AS Available_Investment_Records,
    COUNT(*) - COUNT(Investment_Amount) AS Missing_Investment_Records,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    SUM(Investment_Amount) AS Total_Recorded_Investment_Amount,
    CAST(AVG(Investment_Amount) AS DECIMAL(18,2))
        AS Average_Investment_Amount,
    MIN(Investment_Amount) AS Minimum_Investment_Amount,
    MAX(Investment_Amount) AS Maximum_Investment_Amount
FROM dbo.Transactions_Clean;
GO


/* 2. INVESTMENT TYPE DISTRIBUTION */

SELECT
    COALESCE(Investment_Type, 'Unknown') AS Investment_Type,
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    SUM(Investment_Amount) AS Total_Recorded_Investment_Amount,
    CAST(AVG(Investment_Amount) AS DECIMAL(18,2))
        AS Average_Investment_Amount
FROM dbo.Transactions_Clean
GROUP BY Investment_Type
ORDER BY Total_Recorded_Investment_Amount DESC;
GO


/* 3. INVESTMENT AMOUNT DISTRIBUTION */

SELECT
    CASE
        WHEN Investment_Amount < 1000 THEN 'Below 1,000'
        WHEN Investment_Amount BETWEEN 1000 AND 4999 THEN '1,000-4,999'
        WHEN Investment_Amount BETWEEN 5000 AND 9999 THEN '5,000-9,999'
        WHEN Investment_Amount BETWEEN 10000 AND 24999 THEN '10,000-24,999'
        WHEN Investment_Amount BETWEEN 25000 AND 49999 THEN '25,000-49,999'
        ELSE '50,000 and Above'
    END AS Investment_Amount_Range,
    COUNT(*) AS Total_Records,
    CAST(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS Record_Percentage
FROM dbo.Transactions_Clean
WHERE Investment_Amount IS NOT NULL
GROUP BY
    CASE
        WHEN Investment_Amount < 1000 THEN 'Below 1,000'
        WHEN Investment_Amount BETWEEN 1000 AND 4999 THEN '1,000-4,999'
        WHEN Investment_Amount BETWEEN 5000 AND 9999 THEN '5,000-9,999'
        WHEN Investment_Amount BETWEEN 10000 AND 24999 THEN '10,000-24,999'
        WHEN Investment_Amount BETWEEN 25000 AND 49999 THEN '25,000-49,999'
        ELSE '50,000 and Above'
    END
ORDER BY MIN(Investment_Amount);
GO


/* 4. INVESTMENT ACTIVITY BY CUSTOMER TYPE */

SELECT
    COALESCE(c.Customer_Type, 'Unknown') AS Customer_Type,
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT t.Customer_ID) AS Unique_Customers,
    SUM(t.Investment_Amount) AS Total_Recorded_Investment_Amount,
    CAST(AVG(t.Investment_Amount) AS DECIMAL(18,2))
        AS Average_Investment_Amount
FROM dbo.Transactions_Clean AS t
INNER JOIN dbo.Customer_Clean AS c
    ON t.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Type
ORDER BY Total_Recorded_Investment_Amount DESC;
GO


/* 5. INVESTMENT ACTIVITY BY REGION */

SELECT
    c.Region,
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT t.Customer_ID) AS Unique_Customers,
    SUM(t.Investment_Amount) AS Total_Recorded_Investment_Amount,
    CAST(AVG(t.Investment_Amount) AS DECIMAL(18,2))
        AS Average_Investment_Amount
FROM dbo.Transactions_Clean AS t
INNER JOIN dbo.Customer_Clean AS c
    ON t.Customer_ID = c.Customer_ID
GROUP BY c.Region
ORDER BY Total_Recorded_Investment_Amount DESC;
GO


/* 6. INVESTMENT ACTIVITY BY ACCOUNT TYPE */

SELECT
    t.Account_Type,
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT t.Customer_ID) AS Unique_Customers,
    SUM(t.Investment_Amount) AS Total_Recorded_Investment_Amount,
    CAST(AVG(t.Investment_Amount) AS DECIMAL(18,2))
        AS Average_Investment_Amount
FROM dbo.Transactions_Clean AS t
GROUP BY t.Account_Type
ORDER BY Total_Recorded_Investment_Amount DESC;
GO


/* 7. MONTHLY INVESTMENT TREND */

SELECT
    YEAR(Transaction_Date) AS Investment_Year,
    MONTH(Transaction_Date) AS Investment_Month,
    DATENAME(MONTH, Transaction_Date) AS Month_Name,
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    SUM(Investment_Amount) AS Total_Recorded_Investment_Amount,
    CAST(AVG(Investment_Amount) AS DECIMAL(18,2))
        AS Average_Investment_Amount
FROM dbo.Transactions_Clean
GROUP BY
    YEAR(Transaction_Date),
    MONTH(Transaction_Date),
    DATENAME(MONTH, Transaction_Date)
ORDER BY
    Investment_Year,
    Investment_Month;
GO


/* 8. YEAR-WISE INVESTMENT ANALYSIS */

SELECT
    YEAR(Transaction_Date) AS Investment_Year,
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    SUM(Investment_Amount) AS Total_Recorded_Investment_Amount,
    CAST(AVG(Investment_Amount) AS DECIMAL(18,2))
        AS Average_Investment_Amount
FROM dbo.Transactions_Clean
GROUP BY YEAR(Transaction_Date)
ORDER BY Investment_Year;
GO


/* 9. TOP 20 CUSTOMERS BY RECORDED INVESTMENT AMOUNT */

SELECT TOP 20
    Customer_ID,
    COUNT(*) AS Total_Investment_Records,
    SUM(Investment_Amount) AS Total_Recorded_Investment_Amount,
    CAST(AVG(Investment_Amount) AS DECIMAL(18,2))
        AS Average_Investment_Amount,
    MAX(Investment_Amount) AS Highest_Recorded_Investment
FROM dbo.Transactions_Clean
GROUP BY Customer_ID
ORDER BY Total_Recorded_Investment_Amount DESC;
GO


/* 10. INVESTMENT TYPE BY CUSTOMER TYPE */

SELECT
    COALESCE(c.Customer_Type, 'Unknown') AS Customer_Type,
    COALESCE(t.Investment_Type, 'Unknown') AS Investment_Type,
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT t.Customer_ID) AS Unique_Customers,
    SUM(t.Investment_Amount) AS Total_Recorded_Investment_Amount
FROM dbo.Transactions_Clean AS t
INNER JOIN dbo.Customer_Clean AS c
    ON t.Customer_ID = c.Customer_ID
GROUP BY
    c.Customer_Type,
    t.Investment_Type
ORDER BY
    Customer_Type,
    Total_Recorded_Investment_Amount DESC;
GO


/* 11. INVESTMENT DATA QUALITY CHECK */

SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN Investment_Amount IS NULL THEN 1 ELSE 0 END)
        AS Missing_Investment_Amounts,
    SUM(CASE WHEN Investment_Amount = 0 THEN 1 ELSE 0 END)
        AS Zero_Investment_Amounts,
    SUM(CASE WHEN Investment_Amount < 0 THEN 1 ELSE 0 END)
        AS Negative_Investment_Amounts,
    SUM(CASE WHEN Investment_Type IS NULL THEN 1 ELSE 0 END)
        AS Missing_Investment_Types,
    SUM(CASE WHEN Investment_Amount > 0 THEN 1 ELSE 0 END)
        AS Positive_Investment_Amounts
FROM dbo.Transactions_Clean;
GO


/* 12. INVESTMENT TYPE PROFILE */

SELECT
    Investment_Type,
    COUNT(*) AS Total_Records,
    MIN(Investment_Amount) AS Minimum_Investment_Amount,
    MAX(Investment_Amount) AS Maximum_Investment_Amount,
    CAST(AVG(Investment_Amount) AS DECIMAL(18,2))
        AS Average_Investment_Amount
FROM dbo.Transactions_Clean
GROUP BY Investment_Type
ORDER BY Total_Records DESC;
GO
