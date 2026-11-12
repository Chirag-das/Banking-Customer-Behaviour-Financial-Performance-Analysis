
USE Banking_Analytics;
GO

/*====================================================
  TRANSACTION ANALYSIS
  Project: Banking Customer Behaviour &
           Financial Performance Analysis
====================================================*/


/* 1. OVERALL TRANSACTION OVERVIEW */

SELECT
    COUNT(*) AS Total_Transaction_Records,
    COUNT(DISTINCT Transaction_ID) AS Unique_Transactions,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    COUNT(Transaction_Amount) AS Available_Transaction_Amounts,
    SUM(Transaction_Amount) AS Total_Recorded_Transaction_Amount,
    CAST(AVG(Transaction_Amount) AS DECIMAL(18,2))
        AS Average_Transaction_Amount,
    MIN(Transaction_Amount) AS Minimum_Transaction_Amount,
    MAX(Transaction_Amount) AS Maximum_Transaction_Amount,
    MIN(Transaction_Date) AS First_Transaction_Date,
    MAX(Transaction_Date) AS Last_Transaction_Date
FROM dbo.Transactions_Clean;
GO


/* 2. TRANSACTION AMOUNT DISTRIBUTION */

SELECT
    CASE
        WHEN Transaction_Amount < 1000 THEN 'Below 1,000'
        WHEN Transaction_Amount BETWEEN 1000 AND 4999 THEN '1,000-4,999'
        WHEN Transaction_Amount BETWEEN 5000 AND 9999 THEN '5,000-9,999'
        WHEN Transaction_Amount BETWEEN 10000 AND 24999 THEN '10,000-24,999'
        WHEN Transaction_Amount BETWEEN 25000 AND 49999 THEN '25,000-49,999'
        ELSE '50,000 and Above'
    END AS Transaction_Amount_Range,
    COUNT(*) AS Total_Transactions,
    CAST(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS Transaction_Percentage
FROM dbo.Transactions_Clean
WHERE Transaction_Amount IS NOT NULL
GROUP BY
    CASE
        WHEN Transaction_Amount < 1000 THEN 'Below 1,000'
        WHEN Transaction_Amount BETWEEN 1000 AND 4999 THEN '1,000-4,999'
        WHEN Transaction_Amount BETWEEN 5000 AND 9999 THEN '5,000-9,999'
        WHEN Transaction_Amount BETWEEN 10000 AND 24999 THEN '10,000-24,999'
        WHEN Transaction_Amount BETWEEN 25000 AND 49999 THEN '25,000-49,999'
        ELSE '50,000 and Above'
    END
ORDER BY MIN(Transaction_Amount);
GO


/* 3. ACCOUNT TYPE DISTRIBUTION */

SELECT
    Account_Type,
    COUNT(*) AS Total_Transactions,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    SUM(Transaction_Amount) AS Total_Recorded_Transaction_Amount,
    CAST(AVG(Transaction_Amount) AS DECIMAL(18,2))
        AS Average_Transaction_Amount
FROM dbo.Transactions_Clean
GROUP BY Account_Type
ORDER BY Total_Transactions DESC;
GO


/* 4. MONTHLY TRANSACTION TREND */

SELECT
    YEAR(Transaction_Date) AS Transaction_Year,
    MONTH(Transaction_Date) AS Transaction_Month,
    DATENAME(MONTH, Transaction_Date) AS Month_Name,
    COUNT(*) AS Total_Transactions,
    SUM(Transaction_Amount) AS Total_Recorded_Transaction_Amount,
    CAST(AVG(Transaction_Amount) AS DECIMAL(18,2))
        AS Average_Transaction_Amount
FROM dbo.Transactions_Clean
GROUP BY
    YEAR(Transaction_Date),
    MONTH(Transaction_Date),
    DATENAME(MONTH, Transaction_Date)
ORDER BY
    Transaction_Year,
    Transaction_Month;
GO


/* 5. YEAR-WISE TRANSACTION PERFORMANCE */

SELECT
    YEAR(Transaction_Date) AS Transaction_Year,
    COUNT(*) AS Total_Transactions,
    COUNT(DISTINCT Customer_ID) AS Active_Customers,
    SUM(Transaction_Amount) AS Total_Recorded_Transaction_Amount,
    CAST(AVG(Transaction_Amount) AS DECIMAL(18,2))
        AS Average_Transaction_Amount
FROM dbo.Transactions_Clean
GROUP BY YEAR(Transaction_Date)
ORDER BY Transaction_Year;
GO


/* 6. CUSTOMER-WISE TRANSACTION ACTIVITY */

SELECT TOP 20
    Customer_ID,
    COUNT(*) AS Total_Transactions,
    SUM(Transaction_Amount) AS Total_Recorded_Transaction_Amount,
    CAST(AVG(Transaction_Amount) AS DECIMAL(18,2))
        AS Average_Transaction_Amount,
    MAX(Transaction_Amount) AS Highest_Transaction_Amount
FROM dbo.Transactions_Clean
GROUP BY Customer_ID
ORDER BY Total_Transactions DESC;
GO


/* 7. TRANSACTION ACTIVITY BY REGION */

SELECT
    c.Region,
    COUNT(t.Transaction_ID) AS Total_Transactions,
    COUNT(DISTINCT t.Customer_ID) AS Active_Customers,
    SUM(t.Transaction_Amount) AS Total_Recorded_Transaction_Amount,
    CAST(AVG(t.Transaction_Amount) AS DECIMAL(18,2))
        AS Average_Transaction_Amount
FROM dbo.Transactions_Clean AS t
INNER JOIN dbo.Customer_Clean AS c
    ON t.Customer_ID = c.Customer_ID
GROUP BY c.Region
ORDER BY Total_Transactions DESC;
GO


/* 8. TRANSACTION ACTIVITY BY CUSTOMER TYPE */

SELECT
    c.Customer_Type,
    COUNT(t.Transaction_ID) AS Total_Transactions,
    COUNT(DISTINCT t.Customer_ID) AS Unique_Customers,
    SUM(t.Transaction_Amount) AS Total_Recorded_Transaction_Amount,
    CAST(AVG(t.Transaction_Amount) AS DECIMAL(18,2))
        AS Average_Transaction_Amount
FROM dbo.Transactions_Clean AS t
INNER JOIN dbo.Customer_Clean AS c
    ON t.Customer_ID = c.Customer_ID
WHERE c.Customer_Type IS NOT NULL
GROUP BY c.Customer_Type
ORDER BY Total_Transactions DESC;
GO


/* 9. ACCOUNT TYPE BY CUSTOMER TYPE */

SELECT
    c.Customer_Type,
    t.Account_Type,
    COUNT(*) AS Total_Transactions,
    COUNT(DISTINCT t.Customer_ID) AS Unique_Customers
FROM dbo.Transactions_Clean AS t
INNER JOIN dbo.Customer_Clean AS c
    ON t.Customer_ID = c.Customer_ID
WHERE c.Customer_Type IS NOT NULL
GROUP BY
    c.Customer_Type,
    t.Account_Type
ORDER BY
    c.Customer_Type,
    Total_Transactions DESC;
GO


/* 10. TRANSACTION ACTIVITY BY DAY OF WEEK */

SELECT
    DATENAME(WEEKDAY, Transaction_Date) AS Day_Name,
    COUNT(*) AS Total_Transactions,
    SUM(Transaction_Amount) AS Total_Recorded_Transaction_Amount,
    CAST(AVG(Transaction_Amount) AS DECIMAL(18,2))
        AS Average_Transaction_Amount
FROM dbo.Transactions_Clean
GROUP BY
    DATEPART(WEEKDAY, Transaction_Date),
    DATENAME(WEEKDAY, Transaction_Date)
ORDER BY DATEPART(WEEKDAY, Transaction_Date);
GO


/* 11. TRANSACTION AMOUNT QUALITY CHECK */

SELECT
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN Transaction_Amount IS NULL THEN 1 ELSE 0 END)
        AS Missing_Transaction_Amounts,
    SUM(CASE WHEN Transaction_Amount = 0 THEN 1 ELSE 0 END)
        AS Zero_Amount_Transactions,
    SUM(CASE WHEN Transaction_Amount < 0 THEN 1 ELSE 0 END)
        AS Negative_Amount_Transactions,
    SUM(CASE WHEN Transaction_Amount > 0 THEN 1 ELSE 0 END)
        AS Positive_Amount_Transactions
FROM dbo.Transactions_Clean;
GO


/* 12. TRANSACTION ID DUPLICATE CHECK */

SELECT
    Transaction_ID,
    COUNT(*) AS Duplicate_Count
FROM dbo.Transactions_Clean
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;
GO


/* 13. BALANCE FIELD PROFILE */

SELECT
    COUNT(Total_Balance) AS Available_Balance_Records,
    CAST(AVG(Total_Balance) AS DECIMAL(18,2))
        AS Average_Recorded_Balance,
    MIN(Total_Balance) AS Minimum_Recorded_Balance,
    MAX(Total_Balance) AS Maximum_Recorded_Balance,
    SUM(CASE WHEN Total_Balance < 0 THEN 1 ELSE 0 END)
        AS Negative_Balance_Records,
    SUM(CASE WHEN Total_Balance = 0 THEN 1 ELSE 0 END)
        AS Zero_Balance_Records
FROM dbo.Transactions_Clean;
GO
