USE Banking_Analytics;
GO

-- Banking Financial Performance Overview

SELECT
    COUNT(*) AS Total_Branches,
    COUNT(Firm_Revenue) AS Available_Revenue_Records,
    COUNT(*) - COUNT(Firm_Revenue) AS Missing_Revenue_Records,
    SUM(Firm_Revenue) AS Total_Revenue,
    SUM(Expenses) AS Total_Expenses,
    AVG(Firm_Revenue) AS Average_Revenue,
    AVG(Expenses) AS Average_Expenses,
    AVG(Profit_Margin) AS Average_Reported_Profit_Margin,
    MIN(Firm_Revenue) AS Minimum_Revenue,
    MAX(Firm_Revenue) AS Maximum_Revenue
FROM dbo.Bank_Clean;
GO

-- Regional Banking Financial Performance

SELECT
    Region,
    COUNT(*) AS Total_Branches,

    COUNT(Firm_Revenue) AS Branches_With_Revenue,

    SUM(Firm_Revenue) AS Total_Revenue,

    SUM(Expenses) AS Total_Expenses,

    SUM(
        CASE
            WHEN Firm_Revenue IS NOT NULL
            THEN Expenses
            ELSE 0
        END
    ) AS Expenses_For_Branches_With_Revenue,

    AVG(Profit_Margin) AS Average_Reported_Profit_Margin

FROM dbo.Bank_Clean
GROUP BY Region
ORDER BY Total_Revenue DESC;
GO

-- Regional Revenue Contribution

WITH Regional_Revenue AS
(
    SELECT
        Region,
        SUM(Firm_Revenue) AS Total_Revenue
    FROM dbo.Bank_Clean
    GROUP BY Region
)

SELECT
    Region,
    Total_Revenue,

    CAST(
        Total_Revenue * 100.0 /
        SUM(Total_Revenue) OVER ()
        AS DECIMAL(10,2)
    ) AS Revenue_Contribution_Percentage

FROM Regional_Revenue
ORDER BY Total_Revenue DESC;
GO

-- Top 10 Branches by Revenue

SELECT TOP 10
    Branch_ID,
    City,
    Region,
    Firm_Revenue,
    Expenses,
    Profit_Margin AS Reported_Profit_Margin

FROM dbo.Bank_Clean

WHERE Firm_Revenue IS NOT NULL

ORDER BY Firm_Revenue DESC;
GO

-- Compare Reported vs Calculated Profit Margin

SELECT TOP 10
    Branch_ID,
    City,
    Region,
    Firm_Revenue,
    Expenses,

    Firm_Revenue - Expenses AS Calculated_Profit,

    Profit_Margin AS Reported_Profit_Margin,

    CAST(
        (Firm_Revenue - Expenses) * 100.0 /
        NULLIF(Firm_Revenue, 0)
        AS DECIMAL(10,2)
    ) AS Calculated_Profit_Margin

FROM dbo.Bank_Clean

WHERE Firm_Revenue IS NOT NULL
  AND Firm_Revenue <> 0

ORDER BY Firm_Revenue DESC;
GO

-- Overall Profit Margin Reconciliation

SELECT
    COUNT(*) AS Total_Branches_With_Revenue,

    SUM(
        CASE
            WHEN ABS(
                Profit_Margin -
                ((Firm_Revenue - Expenses) * 100.0 /
                 NULLIF(Firm_Revenue, 0))
            ) > 0.01
            THEN 1 ELSE 0
        END
    ) AS Inconsistent_Margin_Records,

    SUM(
        CASE
            WHEN ABS(
                Profit_Margin -
                ((Firm_Revenue - Expenses) * 100.0 /
                 NULLIF(Firm_Revenue, 0))
            ) <= 0.01
            THEN 1 ELSE 0
        END
    ) AS Consistent_Margin_Records

FROM dbo.Bank_Clean
WHERE Firm_Revenue IS NOT NULL
  AND Firm_Revenue <> 0
  AND Profit_Margin IS NOT NULL;
GO