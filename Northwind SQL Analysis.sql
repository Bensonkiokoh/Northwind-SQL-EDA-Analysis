
USE NorthWind

--Database Exploration

SELECT * 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

SELECT 
TABLE_NAME,
COLUMN_NAME,
ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('Employees','Customers')
ORDER BY TABLE_NAME, ORDINAL_POSITION ASC;

--Which countries have the most customers?

SELECT Country , COUNT(CustomerID) TotalCustomers
FROM Customers
GROUP BY Country
ORDER BY TotalCustomers DESC

--Who are the top 10 customers by total orders?

SELECT TOP 10 C.CompanyName ,COUNT(O.OrderID) TotalOrders
FROM Customers C
INNER JOIN Orders O ON C.CustomerID =O.CustomerID
GROUP BY C.CompanyName
ORDER BY TotalOrders DESC

--Top 10 customers by total revenue

SELECT TOP 10
	C.CustomerID,C.CompanyName, ROUND(SUM(OD.UnitPrice * OD.Quantity * (1- OD.Discount)),2) TotalRevenue
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] OD ON O.OrderID =OD.OrderID
GROUP BY C.CompanyName,C.CustomerID
ORDER BY TotalRevenue DESC

--What are the top 10 best-selling products by quantity sold?

SELECT TOP 10
	P.ProductName ,SUM(OD.Quantity) TotalQuantity
FROM Products P
INNER JOIN [Order Details] OD ON P.ProductID =OD.ProductID
GROUP BY P.ProductName
ORDER BY TotalQuantity DESC

--Which products generate the highest revenue?

SELECT TOP 10
	P.ProductName ,ROUND(SUM(OD.UnitPrice * OD.Quantity * (1- od.Discount)),2) TotalRevenue
FROM Products P
INNER JOIN [Order Details] OD ON P.ProductID =OD.ProductID
GROUP BY P.ProductName
ORDER BY TotalRevenue DESC

--Which categories are the most profitable?

SELECT 
	C.CategoryName , ROUND(SUM(OD.UnitPrice * OD.Quantity * (1- od.Discount)),2) TotalRevenue
FROM Categories C
INNER JOIN Products P ON C.CategoryID =P.CategoryID
INNER JOIN [Order Details] OD ON P.ProductID =OD.ProductID
GROUP BY C.CategoryName
ORDER BY TotalRevenue DESC

--How many units are in stock vs. on order per product?

SELECT 
	ProductName, UnitsInStock , UnitsOnOrder
FROM Products
ORDER BY UnitsInStock DESC


--How do orders trend month by month?

SELECT	
	FORMAT(Orderdate, 'yyyy-MM') OrderMonth,
	COUNT(OrderID) TotalOrders
FROM Orders
WHERE OrderDate IS NOT NULL
GROUP BY FORMAT(Orderdate, 'yyyy-MM')
ORDER BY OrderMonth 

--Which days of the week get the most orders?

SELECT 
	DATENAME(WEEKDAY , Orderdate) OrderDay,
	COUNT(OrderID) TotalOrders
FROM Orders
GROUP BY DATENAME(WEEKDAY , Orderdate)
ORDER BY TotalOrders DESC

--Year-over-year order trend

SELECT 
	YEAR(OrderDate) OrderYear,
	COUNT(OrderID) TotalOrders
FROM Orders
WHERE OrderDate IS NOT NULL
GROUP BY YEAR(OrderDate)
ORDER BY TotalOrders DESC

--Monthly revenue trend

SELECT 
	FORMAT(O.orderdate , 'yyyy-MM') OrderMonth,
	ROUND(SUM(OD.UnitPrice * OD.Quantity * (1-OD.Discount)),2) TotalRevenue
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY FORMAT(O.orderdate , 'yyyy-MM')
ORDER BY OrderMonth

--Yearly revenue trend

SELECT 
	YEAR(OrderDate) OrderYear,
	ROUND(SUM(OD.UnitPrice * OD.Quantity * (1-OD.Discount)),2) TotalRevenue
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear


 --Revenue by weekday

 SELECT 
	DATENAME(WEEKDAY, Orderdate) OrderDay,
	ROUND(SUM(OD.UnitPrice * OD.Quantity * (1-OD.Discount)),2) TotalRevenue
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY DATENAME(WEEKDAY, Orderdate)
ORDER BY TotalRevenue DESC

--Which employees generate the most revenue?

SELECT 
	E.EmployeeID,
	E.FirstName+' '+E.LastName EmployeeName,
	ROUND(SUM(OD.UnitPrice * OD.Quantity * (1-OD.Discount)),2) TotalRevenue
FROM Employees E
INNER JOIN Orders O ON E.EmployeeID =O.EmployeeID
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY E.FirstName+' '+E.LastName , E.EmployeeID
ORDER BY TotalRevenue DESC

--Which employees handle the most orders?

SELECT 
	E.EmployeeID,
	E.FirstName+' '+E.LastName EmployeeName,
	COUNT(o.OrderID) TotalOrders
FROM Employees E
INNER JOIN Orders O ON E.EmployeeID =O.EmployeeID
GROUP BY E.FirstName+' '+E.LastName , E.EmployeeID
ORDER BY TotalOrders DESC
















