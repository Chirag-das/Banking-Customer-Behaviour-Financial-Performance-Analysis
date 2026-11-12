
/*============================================================
  PROJECT: Banking Customer Behaviour & Financial Performance
  SCRIPT: 01 - Database Setup
============================================================*/

USE master;
GO

IF DB_ID('Banking_Analytics') IS NULL
BEGIN
    CREATE DATABASE Banking_Analytics;
    PRINT 'Banking_Analytics database created successfully.';
END
ELSE
BEGIN
    PRINT 'Banking_Analytics database already exists.';
END;
GO

USE Banking_Analytics;
GO

SELECT
    name AS Database_Name,
    state_desc AS Database_Status
FROM sys.databases
WHERE name = 'Banking_Analytics';
GO
