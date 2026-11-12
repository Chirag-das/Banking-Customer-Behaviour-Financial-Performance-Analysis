
USE Banking_Analytics;
GO

/*====================================================
  CUSTOMER BEHAVIOUR ANALYSIS
  Project: Banking Customer Behaviour &
           Financial Performance Analysis
====================================================*/


/* 1. OVERALL CUSTOMER PROFILE */

SELECT
    COUNT(*) AS Total_Customer_Records,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    COUNT(Age) AS Customers_With_Age,
    COUNT(*) - COUNT(Age) AS Missing_Age_Records,
    COUNT(Customer_Type) AS Customers_With_Customer_Type,
    COUNT(*) - COUNT(Customer_Type) AS Missing_Customer_Type_Records,
    COUNT(City) AS Customers_With_City,
    COUNT(*) - COUNT(City) AS Missing_City_Records
FROM dbo.Customer_Clean;
GO


/* 2. CUSTOMER TYPE DISTRIBUTION */

SELECT
    Customer_Type,
    COUNT(*) AS Total_Customers,
    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS Customer_Percentage
FROM dbo.Customer_Clean
GROUP BY Customer_Type
ORDER BY Total_Customers DESC;
GO


/* 3. CUSTOMER AGE ANALYSIS */

SELECT
    COUNT(Age) AS Customers_With_Age,
    CAST(AVG(Age) AS DECIMAL(10,2)) AS Average_Age,
    MIN(Age) AS Minimum_Age,
    MAX(Age) AS Maximum_Age,
    CAST(STDEV(Age) AS DECIMAL(10,2)) AS Age_Standard_Deviation
FROM dbo.Customer_Clean
WHERE Age IS NOT NULL;
GO


/* 4. AGE GROUP DISTRIBUTION */

SELECT
    CASE
        WHEN Age < 18 THEN 'Below 18'
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        WHEN Age BETWEEN 56 AND 65 THEN '56-65'
        ELSE 'Above 65'
    END AS Age_Group,
    COUNT(*) AS Total_Customers,
    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS Customer_Percentage
FROM dbo.Customer_Clean
WHERE Age IS NOT NULL
GROUP BY
    CASE
        WHEN Age < 18 THEN 'Below 18'
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        WHEN Age BETWEEN 56 AND 65 THEN '56-65'
        ELSE 'Above 65'
    END
ORDER BY MIN(Age);
GO


/* 5. CITY-WISE CUSTOMER DISTRIBUTION */

SELECT
    City,
    COUNT(*) AS Total_Customers
FROM dbo.Customer_Clean
WHERE City IS NOT NULL
GROUP BY City
ORDER BY Total_Customers DESC;
GO


/* 6. REGION-WISE CUSTOMER DISTRIBUTION */

SELECT
    Region,
    COUNT(*) AS Total_Customers,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM dbo.Customer_Clean
GROUP BY Region
ORDER BY Total_Customers DESC;
GO


/* 7. BANK-WISE CUSTOMER DISTRIBUTION */

SELECT
    Bank_Name,
    COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM dbo.Customer_Clean
GROUP BY Bank_Name
ORDER BY Total_Customers DESC;
GO


/* 8. BRANCH-WISE CUSTOMER COVERAGE */

SELECT
    c.Branch_ID,
    b.City AS Branch_City,
    b.Region AS Branch_Region,
    COUNT(DISTINCT c.Customer_ID) AS Total_Customers
FROM dbo.Customer_Clean AS c
LEFT JOIN dbo.Bank_Clean AS b
    ON c.Branch_ID = b.Branch_ID
GROUP BY
    c.Branch_ID,
    b.City,
    b.Region
ORDER BY Total_Customers DESC;
GO


/* 9. CUSTOMER TYPE BY REGION */

SELECT
    Region,
    Customer_Type,
    COUNT(*) AS Total_Customers
FROM dbo.Customer_Clean
WHERE Customer_Type IS NOT NULL
GROUP BY
    Region,
    Customer_Type
ORDER BY
    Region,
    Total_Customers DESC;
GO


/* 10. CUSTOMER TYPE BY AGE GROUP */

SELECT
    Customer_Type,
    CASE
        WHEN Age < 18 THEN 'Below 18'
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        WHEN Age BETWEEN 56 AND 65 THEN '56-65'
        ELSE 'Above 65'
    END AS Age_Group,
    COUNT(*) AS Total_Customers
FROM dbo.Customer_Clean
WHERE
    Customer_Type IS NOT NULL
    AND Age IS NOT NULL
GROUP BY
    Customer_Type,
    CASE
        WHEN Age < 18 THEN 'Below 18'
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        WHEN Age BETWEEN 56 AND 65 THEN '56-65'
        ELSE 'Above 65'
    END
ORDER BY
    Customer_Type,
    MIN(Age);
GO


/* 11. CUSTOMER DATA QUALITY SUMMARY */

SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END)
        AS Missing_Age,
    SUM(CASE WHEN Customer_Type IS NULL THEN 1 ELSE 0 END)
        AS Missing_Customer_Type,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END)
        AS Missing_City,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END)
        AS Missing_Region,
    SUM(CASE WHEN Bank_Name IS NULL THEN 1 ELSE 0 END)
        AS Missing_Bank_Name,
    SUM(CASE WHEN Branch_ID IS NULL THEN 1 ELSE 0 END)
        AS Missing_Branch_ID
FROM dbo.Customer_Clean;
GO


/* 12. CUSTOMER ID DUPLICATE CHECK */

SELECT
    Customer_ID,
    COUNT(*) AS Duplicate_Count
FROM dbo.Customer_Clean
GROUP BY Customer_ID
HAVING COUNT(*) > 1;
GO


SELECT
    COUNT(*) AS Total_Customers,

    SUM(CASE
        WHEN Age IS NULL
         AND Customer_Type IS NULL
         AND City IS NULL
        THEN 1 ELSE 0
    END) AS All_Three_Missing,

    SUM(CASE
        WHEN Age IS NULL
          OR Customer_Type IS NULL
          OR City IS NULL
        THEN 1 ELSE 0
    END) AS At_Least_One_Missing,

    SUM(CASE
        WHEN Age IS NOT NULL
         AND Customer_Type IS NOT NULL
         AND City IS NOT NULL
        THEN 1 ELSE 0
    END) AS Complete_Profiles

FROM dbo.Customer_Clean;