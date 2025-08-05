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
### What columns does each table have?
```
SELECT 
TABLE_NAME,
COLUMN_NAME,
ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME, ORDINAL_POSITION ASC;
```
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
### Who are the top 10 customers by total orders?
```
SELECT TOP 10 C.CompanyName ,COUNT(O.OrderID) TotalOrders
FROM Customers C
INNER JOIN Orders O ON C.CustomerID =O.CustomerID
GROUP BY C.CompanyName
ORDER BY TotalOrders DESC
```



















