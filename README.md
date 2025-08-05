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

<img width="926" height="540" alt="ERD" src="https://github.com/user-attachments/assets/086b48f7-0faf-4366-978e-6f8dc413113b" />


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

### Which products generate the highest revenue?
```
SELECT TOP 10
	P.ProductName ,ROUND(SUM(OD.UnitPrice * OD.Quantity * (1- od.Discount)),2) TotalRevenue
FROM Products P
INNER JOIN [Order Details] OD ON P.ProductID =OD.ProductID
GROUP BY P.ProductName
ORDER BY TotalRevenue DESC
```
<img width="218" height="211" alt="Revenue" src="https://github.com/user-attachments/assets/bacba634-4831-447c-9ad3-2a44ef946904" />

#### Insight:
Some products sell fewer units but generate more revenue. This helps focus on high-margin or high-value items.

### Which categories are the most profitable?
```
SELECT 
	C.CategoryName , ROUND(SUM(OD.UnitPrice * OD.Quantity * (1- od.Discount)),2) TotalRevenue
FROM Categories C
INNER JOIN Products P ON C.CategoryID =P.CategoryID
INNER JOIN [Order Details] OD ON P.ProductID =OD.ProductID
GROUP BY C.CategoryName
ORDER BY TotalRevenue DESC
```
<img width="174" height="172" alt="Category" src="https://github.com/user-attachments/assets/5c1e06a4-6c24-4a02-8840-e4607a7a448b" />

#### Insight:
Looking at performance by category helps understand which product groups are driving revenue and which might need review.

### How many units are in stock vs. on order per product?
```
SELECT 
	ProductName, UnitsInStock , UnitsOnOrder
FROM Products
```
<img width="333" height="250" alt="Screenshot 2025-08-05 125053" src="https://github.com/user-attachments/assets/7263d24d-7a25-43a8-ab5b-44cf0b4b4b05" />

#### Insight:
This highlights products that may need restocking or where supply isn’t keeping up with demand.

## Sales Trends
Here I wanted to answer: When are people buying? This section digs into order activity over time to uncover patterns, seasonality, and overall sales momentum.

### How do orders trend month by month?
```
SELECT	
	FORMAT(Orderdate, 'yyyy-MM') OrderMonth,
	COUNT(OrderID) TotalOrders
FROM Orders
WHERE OrderDate IS NOT NULL
GROUP BY FORMAT(Orderdate, 'yyyy-MM')
ORDER BY OrderMonth 
```
<img width="147" height="264" alt="Screenshot 2025-08-05 144941" src="https://github.com/user-attachments/assets/3ea2c11a-4805-47b8-9d76-5cc2696d8d7e" />

#### Insight:
This shows how active each month is in terms of order volume. 

### Which days of the week get the most orders?
```
SELECT 
	DATENAME(WEEKDAY , Orderdate) OrderDay,
	COUNT(OrderID) TotalOrders
FROM Orders
GROUP BY DATENAME(WEEKDAY , Orderdate)
ORDER BY TotalOrders DESC
```

<img width="148" height="119" alt="Screenshot 2025-08-05 145656" src="https://github.com/user-attachments/assets/23aa3b4d-4ca9-4e65-8b28-84a8ed52fcad" />

#### Insight:
This reveals buying behavior across the week. You’ll see which days customers are most active, which is helpful for staffing, promotions, and delivery planning.

### Year-over-year order trend
```
SELECT 
	YEAR(OrderDate) OrderYear,
	COUNT(OrderID) TotalOrders
FROM Orders
WHERE OrderDate IS NOT NULL
GROUP BY YEAR(OrderDate)
ORDER BY TotalOrders DESC
```
<img width="138" height="81" alt="Screenshot 2025-08-05 150130" src="https://github.com/user-attachments/assets/2d678640-4e5a-4fb3-80ad-4e21490ff511" />

#### Insight:
This gives a big-picture view of whether business activity is growing or dropping year over year.

## Revenue Trends
Order volume tells you how busy things are revenue shows what actually matters. In this step, I looked at when the business earns the most, how it changes over time, and which days bring in the biggest sales.

### Monthly revenue trend
```
SELECT 
	FORMAT(O.orderdate , 'yyyy-MM') OrderMonth,
	ROUND(SUM(OD.UnitPrice * OD.Quantity * (1-OD.Discount)),2) TotalRevenue
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY FORMAT(O.orderdate , 'yyyy-MM')
ORDER BY OrderMonth
```
<img width="159" height="379" alt="Screenshot 2025-08-05 151647" src="https://github.com/user-attachments/assets/c72aff79-1024-4b32-85b2-2637c95652b4" />

#### Insight:
This shows how revenue fluctuates each month. It’s useful for spotting seasonal highs and lows, not just busy periods.

### Yearly revenue trend
```
SELECT 
	YEAR(OrderDate) OrderYear,
	ROUND(SUM(OD.UnitPrice * OD.Quantity * (1-OD.Discount)),2) TotalRevenue
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear
```
<img width="150" height="81" alt="Screenshot 2025-08-05 152111" src="https://github.com/user-attachments/assets/09865186-8310-493a-8fab-15532c2a18d8" />

#### Insight:
A clear view of growth or decline over time—ideal for long-term planning or investor reporting.

###  Revenue by weekday
```
 SELECT 
	DATENAME(WEEKDAY, Orderdate) OrderDay,
	ROUND(SUM(OD.UnitPrice * OD.Quantity * (1-OD.Discount)),2) TotalRevenue
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY DATENAME(WEEKDAY, Orderdate)
ORDER BY TotalRevenue DESC
```
<img width="162" height="121" alt="Screenshot 2025-08-05 152644" src="https://github.com/user-attachments/assets/a50cf263-79fb-4942-806c-e38d6cc3439a" />

#### Insight:
Tells you which days of the week actually bring in the most cash—not just the most orders. Great for planning marketing or promotions.

## Employee Performance
Since every order is linked to an employee, it’s easy to see who's doing the most and who's bringing in the most. I looked at both order volume and total revenue to spot the top performers.

### Which employees generate the most revenue?
```
SELECT 
	E.EmployeeID,
	E.FirstName+' '+E.LastName EmployeeName,
	ROUND(SUM(OD.UnitPrice * OD.Quantity * (1-OD.Discount)),2) TotalRevenue
FROM Employees E
INNER JOIN Orders O ON E.EmployeeID =O.EmployeeID
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY E.FirstName+' '+E.LastName , E.EmployeeID
ORDER BY TotalRevenue DESC
```
<img width="265" height="194" alt="Screenshot 2025-08-05 155231" src="https://github.com/user-attachments/assets/8db27f34-231a-45f9-ba5b-73b115b62141" />

### Which employees handle the most orders?
```
SELECT 
	E.EmployeeID,
	E.FirstName+' '+E.LastName EmployeeName,
	COUNT(o.OrderID) TotalOrders
FROM Employees E
INNER JOIN Orders O ON E.EmployeeID =O.EmployeeID
GROUP BY E.FirstName+' '+E.LastName , E.EmployeeID
ORDER BY TotalOrders DESC
```
<img width="252" height="194" alt="Screenshot 2025-08-05 155716" src="https://github.com/user-attachments/assets/47992fdc-d0d5-4bdd-b2f5-24cc8cfa35e3" />

#### Insight:
This shows who's responsible for the most order activity. High volume doesn’t always mean high revenue, but it’s a strong indicator of workload.










