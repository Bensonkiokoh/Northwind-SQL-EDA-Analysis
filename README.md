# Northwind-SQL-EDA-Analysis

## Introduction

This project is a full exploratory data analysis (EDA) of the Northwind database using pure SQL. Northwind is a classic dataset that simulates a retail company’s operations, including customers, orders, products, employees, suppliers, and shipping.

The goal of this analysis is to explore key business questions such as:
- Who are the top customers?
- What are the best-selling products?
- How do sales trends vary over time?
- Which employees handle the most orders?
- How fast are orders being fulfilled?

## Database Exploration
Before diving into analysis, I needed to understand the structure of the Northwind database what tables exist, what kind of data they hold, and how they connect.

### What Tables are in the database?
```
SELECT * 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
```
<img width="426" height="286" alt="DBTable" src="https://github.com/user-attachments/assets/aa7328ee-f88b-4f7b-89db-d2e8d88fc9d7" />

### What columns does each table have?
```
SELECT 
TABLE_NAME,
COLUMN_NAME,
ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME, ORDINAL_POSITION ASC;
```
<img width="311" height="363" alt="DBTabe" src="https://github.com/user-attachments/assets/ec5078d8-93c6-4fa9-a3a8-891d5572a652" />

### Entity Relationship Diagram (ERD)
To make sense of how the tables connect, I mapped out the core relationships in the Northwind database. This helped guide the joins I used in the analysis.

<img width="904" height="493" alt="Northwind ERD" src="https://github.com/user-attachments/assets/415b14a3-7259-48b6-a39e-015b07048d1d" />

## Customer Insights
After understanding the structure, I started with the Customers table to answer a few key questions:
### Which Countries had the most Customers?
```
SELECT Country , COUNT(CustomerID) TotalCustomers
FROM Customers
GROUP BY Country
ORDER BY TotalCustomers DESC
```
<img width="163" height="214" alt="Cstmer" src="https://github.com/user-attachments/assets/b0badf54-efc8-42a9-b31d-08b9a5a988d7" />

### Who are the top 10 customers by total orders?
```
SELECT TOP 10 C.CompanyName ,COUNT(O.OrderID) TotalOrders
FROM Customers C
INNER JOIN Orders O ON C.CustomerID =O.CustomerID
GROUP BY C.CompanyName
ORDER BY TotalOrders DESC
```
<img width="226" height="210" alt="TopCstmer" src="https://github.com/user-attachments/assets/85667104-a88d-4d27-b461-e80df392644b" />

These are your most engaged customers. If you're doing account-based strategies, these are the ones to prioritize.

### Who are the top 10 customers by total revenue
```
SELECT TOP 10
	C.CustomerID,C.CompanyName, ROUND(SUM(OD.UnitPrice * OD.Quantity * (1- OD.Discount)),2) TotalRevenue
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] OD ON O.OrderID =OD.OrderID
GROUP BY C.CompanyName,C.CustomerID
ORDER BY TotalRevenue DESC
```
<img width="312" height="212" alt="CRevenue" src="https://github.com/user-attachments/assets/56758e57-4854-40e8-a38d-e51dfdacc9ac" />

#### Insight:
High order count doesn’t always mean high revenue. This query shows you the real top line contributors.

## Product Analysis
In this part, I looked at what’s actually selling by volume and revenue. The goal was to spot top performing products, see which categories bring in the most money, and check if inventory levels align with demand.

### What are the top 10 best-selling products by quantity sold?
```
SELECT TOP 10
	P.ProductName ,SUM(OD.Quantity) TotalQuantity
FROM Products P
INNER JOIN [Order Details] OD ON P.ProductID =OD.ProductID
GROUP BY P.ProductName
ORDER BY TotalQuantity DESC
```
<img width="238" height="214" alt="Top Products" src="https://github.com/user-attachments/assets/4da0e1ec-2fb4-4cda-8bff-a5971a7b4315" />

#### Insight:
These are the high-volume movers. Knowing what sells most helps with inventory planning, pricing strategy, and prioritizing reorders.











































