# Banking Customer Behaviour & Financial Performance Analysis

## 1. Project Overview

This project is an end-to-end banking analytics case study focused on understanding banking performance, customer behaviour, transaction activity, and investment patterns.

The objective is to transform raw banking datasets into meaningful business insights using SQL Server, Python, and Power BI.

The project follows a structured analytical workflow involving data exploration, data profiling, quality assessment, SQL-based analysis, Python validation, data modelling, and interactive dashboard development.

The final Power BI report consists of three analytical pages designed to provide insights into different aspects of banking operations.

---

## 2. Business Objectives

The primary objectives of this project are:

- Analyse overall banking and branch-level financial performance.
- Evaluate revenue, expenses, calculated profit, and profit margins.
- Understand customer demographics and customer-type distribution.
- Analyse transaction activity and investment patterns.
- Identify missing values, inconsistencies, and data-quality issues.
- Develop meaningful business KPIs and analytical measures.
- Build interactive dashboards to communicate business findings.

---

## 3. Technology Stack

| Technology | Purpose |
|---|---|
| Microsoft SQL Server | Data exploration, profiling, validation, and business analysis |
| Python | Selected data validation using Pandas and NumPy |
| Power BI | Data modelling, DAX calculations, and interactive dashboards |

---

## 4. Dataset Overview

The project uses three related datasets containing 21,000 records in total.

| Dataset | Records | Columns | Description |
|---|---:|---:|---|
| Bank | 1,000 | 6 | Branch and financial performance information |
| Customer | 10,000 | 7 | Customer profiles and branch information |
| Transaction | 10,000 | 8 | Transaction and investment-related information |
| **Total** | **21,000** | **21** | **Three related datasets** |

### Key Dataset Fields

**Bank Dataset**
- Branch_ID
- City
- Region
- Firm_Revenue
- Expenses
- Reported_Profit_Margin

**Customer Dataset**
- Customer_ID
- Customer_Name
- Age
- Customer_Type
- City
- Region
- Branch_ID

**Transaction Dataset**
- Transaction_ID
- Customer_ID
- Account_Type
- Transaction_Amount
- Transaction_Date
- Investment_Type
- Investment_Amount
- Total_Balance

---

## 5. Project Workflow

The project follows these analytical stages:

1. **Data Understanding:** Explored the three datasets, their structures, columns, record counts, and relationships.
2. **Data Profiling:** Examined data completeness, uniqueness, missing values, and distributions.
3. **Data Quality Assessment:** Identified missing customer attributes, financial calculation discrepancies, and relationship consistency.
4. **SQL Analysis:** Used SQL Server for data validation, calculations, aggregations, and business analysis.
5. **Python Validation:** Used Pandas and NumPy for selected validation tasks.
6. **Data Modelling:** Established relationships between Bank, Customer, and Transaction tables in Power BI.
7. **Dashboard Development:** Created DAX measures, KPIs, charts, slicers, and interactive report pages.
8. **Result Validation:** Compared Power BI dashboard outputs against SQL analysis results.

---

## 6. Power BI Dashboard

The Power BI report contains three interactive dashboard pages.

### Page 1: Banking Performance

Focuses on branch-level financial performance and overall banking operations.

Key analysis:
- Total banking revenue
- Total expenses
- Calculated profit
- Calculated profit margin
- City and regional performance
- Top-performing branches
- Geographical distribution of branch performance

<img width="1440" height="797" alt="Banking Performance   Financial Analytics Dashboard" src="https://github.com/user-attachments/assets/d5957dde-a4df-407d-97fc-9ab11ce79c0e" />

### Page 2: Customer Behaviour

Provides insights into the customer base and customer characteristics.

Key analysis:
- Total and unique customers
- Customer-type distribution
- Customer age analysis
- Customer geographical distribution
- Customer profile completeness
- Branch-related customer analysis

<img width="1437" height="803" alt="Customer Behaviour   Demographic Analytics Dashboard" src="https://github.com/user-attachments/assets/e6fe18ca-86e4-48f5-967f-ccb4dfcbfb4a" />

### Page 3: Transaction & Investment Analysis

Examines transaction activity and investment-related information.

Key analysis:
- Total transaction records
- Transaction amount analysis
- Average transaction amount
- Investment amount analysis
- Investment-type distribution
- Account-type analysis
- Transaction trends over time

<img width="1446" height="806" alt="Transactions   Investment Analytics Dashboard" src="https://github.com/user-attachments/assets/c551b4c2-6646-40a5-ae56-800f651e0b49" />

---

## 7. Data Quality Assessment

Data quality checks were performed to evaluate the reliability and consistency of the supplied datasets.

### Key Findings

| Quality Check | Result |
|---|---:|
| Total bank records | 1,000 |
| Bank records with missing revenue | 50 |
| Total customer records | 10,000 |
| Unique customer IDs | 10,000 |
| Missing customer age values | 500 |
| Missing customer type values | 500 |
| Missing customer city values | 500 |
| Total missing cells across these three attributes | 1,500 |
| Total transaction records | 10,000 |
| Unique transaction IDs | 10,000 |
| Missing transaction amounts | 0 |

### Additional Observations

- All customer IDs were unique.
- All transaction IDs were unique.
- All customer branch references matched the Bank dataset.
- All transaction customer references matched the Customer dataset.
- Reported profit margins did not reconcile with conventionally calculated profit margins for the evaluated branches.
- Some customer city and region values differed from their assigned branch locations. These differences were retained rather than automatically treated as errors.

---

## 8. Data Model & Relationships

The Power BI data model uses two one-to-many relationships.

| Primary Table | Related Table | Relationship |
|---|---|---|
| Bank | Customer | Branch_ID |
| Customer | Transaction | Customer_ID |

### Relationship Flow

Bank → Customer → Transaction

This structure supports integrated analysis of branch performance, customer profiles, and transaction activity.

---

## 9. Key Business Analysis Considerations

The analysis highlights several important business considerations:

- Missing customer information can affect demographic analysis and customer segmentation.
- Financial metrics should be validated before being used for business decisions.
- Branch location and customer location represent different business concepts.
- Transaction and investment fields require careful interpretation before drawing financial conclusions.
- Data validation is essential for producing reliable dashboards and business insights.

---

## 10. Project Limitations & Assumptions

- The supplied dataset contains records associated with HDFC Bank. It does not provide comparisons between multiple banks.
- The original dataset source and licence have not been independently verified.
- The source currency has not been independently confirmed. INR and Crore formatting in the dashboard are presentation assumptions, not verified source-currency information.
- Calculated profit and profit margin are analytical indicators, not audited accounting results.
- The transaction dataset does not contain an explicit debit/credit classification. Transaction amounts should not automatically be interpreted as deposits or withdrawals.
- The meaning and aggregation suitability of Total_Balance and Investment_Amount have not been independently verified.
- The available 2025 transaction data covers only part of the year, through 20 March 2025.

**Disclaimer:** This is an independent portfolio project created for educational and analytical purposes. It is not affiliated with, sponsored by, or endorsed by HDFC Bank.

---

## 11. Repository Structure

```text
Banking-Customer-Behaviour-Financial-Performance-Analysis/
│
├── 01_Dataset/
│   └── README.md
│
├── 02_SQL_Analysis/
│   └── README.md
│
├── 03_Python_Analysis/
│   └── README.md
│
├── 04_PowerBI_Dashboard/
│   ├── Banking_Analysis.pbix
│   └── README.md
│
├── 05_Documentation/
│   ├── 01_Business_Requirements_Document_v1.1.docx
│   ├── 02_Business_Insights_and_Findings.docx
│   └── 03_Banking_Data_Dictionary_and_Quality_Assessment.xlsx
│
├── 06_Screenshots/
│   ├── Banking_Performance.png
│   ├── Customer_Behaviour.png
│   └── Transaction_Investment_Analysis.png
│
└── README.md
```

*Note: The filenames shown above are suggested names. Adjust them to match the actual files uploaded to the repository.*

---

## 12. Project Deliverables

- Business Requirements Document (BRD)
- Data Dictionary and Data Quality Assessment
- SQL business analysis queries
- Python validation work
- Interactive Power BI report
- Dashboard screenshots
- Business Insights and Findings documentation

---

## 13. Skills Demonstrated

- SQL querying and data analysis
- Data profiling and data quality assessment
- Data validation and reconciliation
- Python with Pandas and NumPy
- Data modelling and table relationships
- DAX measures and KPI development
- Power BI dashboard development
- Business analysis and insight generation
- Analytical documentation

---

## 14. Author

**Chirag Das**

B.Sc. Information Technology | Aspiring Data Analyst

- **GitHub:** [Chirag Das](https://github.com/Chirag-das)
- **LinkedIn:** [Chirag Das](https://www.linkedin.com/in/chirag-das2208)

---

*This project demonstrates an end-to-end approach to transforming structured banking datasets into meaningful analytical insights and interactive business reports.*
