# Building the Northwind Power BI Model
## Starting with SQL Views
To prepare the Northwind dataset for analysis in Power BI, I started by exploring the raw tables. I focused on three key ones since they hold the bulk of the transactional data:
- Order Details
- Orders
- Products
  
These three tables formed the foundation for the fact view, while other supporting tables like Customers, Suppliers, Employees, Categories, and Shippers provided the attributes for dimension views.

Once I mapped out how the tables connect, I designed a star schema and created an Entity Relationship Diagram (ERD) to visualize the structure before building the SQL views.

## Entity Relationship Diagram

<img width="926" height="540" alt="ERD" src="https://github.com/user-attachments/assets/0d9fc8f1-fc36-4cd4-ab51-ea72c28aa719" />

## SQL View Definitions
To keep the Power BI data model lean, I built SQL views that clean and pre-shape the data before importing. The goal was to centralize the metrics in one fact view and reference attributes through dimension views.

### Fact View: vw_FactOrderDetails
This view combines transactional data from Order Details, Orders, and Products. It captures each line item in an order, along with order metadata and product context.

```sql
CREATE VIEW vw_FactOrderDetails AS
SELECT 
	OD.OrderID,
	OD.ProductID,
	OD.UnitPrice,
	OD.Quantity,
	OD.Discount,
	O.CustomerID,
	O.EmployeeID,
	O.OrderDate,
	O.RequiredDate,
	O.ShippedDate,
	O.ShipVia AS ShipID,
	O.Freight,
	O.ShipName,
	O.ShipCountry,
	P.SupplierID,
	P.CategoryID
FROM [Order Details] OD
INNER JOIN Orders O ON OD.OrderID = O.OrderID
INNER JOIN Products P ON OD.ProductID = P.ProductID;
```
### Dimension Views
To support filtering, slicing, and drilldowns in Power BI, I created separate views for key entities. Each view is small, focused, and joins easily to the fact table.

#### Product Dimension
```sql
CREATE VIEW vw_DimProducts AS
SELECT 
	ProductID,
	ProductName,
	SupplierID,
	CategoryID
FROM Products;
```
#### Category Dimension
```sql
CREATE VIEW vw_DimCategory AS
SELECT 
	CategoryID,
	CategoryName,
	Description
FROM Categories;
```
#### Customer Dimension
```sql
CREATE VIEW vw_DimCustomers AS
SELECT 
	CustomerID,
	CompanyName AS CustomerName,
	City,
	Country
FROM Customers;
```
#### Supplier Dimension
```sql
CREATE VIEW vw_DimSuppliers AS
SELECT 
	SupplierID,
	CompanyName AS SupplierName,
	City,
	Country
FROM Suppliers;
```
#### Shipper Dimension
```sql
CREATE VIEW vw_DimShippers AS
SELECT 
	ShipperID,
	CompanyName AS ShipperName
FROM Shippers;
```
#### Employee Dimension
```sql
CREATE VIEW vw_DimEmployees AS
SELECT 
	EmployeeID,
	FirstName + ' ' + LastName AS EmployeeName,
	BirthDate,
	HireDate,
	City,
	Country
FROM Employees;
```
These views allowed me to build a clean star schema inside Power BI, reduce redundancy, and make the model easier to work with.
## Analysis Objectives: What This Model Aims to Answer
Before moving into Power BI, I laid out the key business questions I wanted the model to help answer.

The goal was to build something that could actually guide smarter decisions.

Here’s what I had in mind:
- Which products and categories are top performers?
- Who are the highest-value customers?
- Which regions drive the most revenue?
- How are individual employees performing on sales?
- Are there any clear trends in monthly or yearly performance?
- What role do discounts play in total revenue and margins?

## Power BI: Modeling and Transformation
### Power Query Cleanup
Once the SQL views were connected in Power BI, I stepped into Power Query to apply a few essential transformations:
- Renamed the tables to remove the vw_ prefix for clarity (e.g., vw_DimCustomers → DimCustomers)
- Profiled the data to check for any issues in structure or content
- No heavy transformations were needed since most of the shaping was handled in SQL

Once confirmed clean, I loaded everything into the Power BI model.

### Data Modeling in Power BI
After cleaning up in Power Query, I switched over to the data model view. Since the relationships were already well defined in SQL and the keys were clean, Power BI automatically detected most of them no manual linking needed.

The model follows a classic star schema. At the center is the FactOrderDetails table, holding all transactional grain: order IDs, products sold, quantities, discounts, prices, and dates.

Surrounding it are the dimension tables Customers, Employees, Products, Categories, Shippers, and Suppliers each providing context for slicing and filtering.

<img width="959" height="736" alt="Data Model" src="https://github.com/user-attachments/assets/f3c79b45-3883-4ea7-b921-459ae2067750" />

###  Data Model Relationships
In the data model, relationships between tables followed a classic 1-to-many pattern with each dimension table (like Products, Categories, Employees, Customers, Shippers, and Suppliers) on the one side, and the fact table FactOrderDetails on the many side.

### Creating the Calendar Table
To enable time-based analysis monthly trends, year-over-year comparisons, or filtering by quarter I needed a proper calendar table.

```sql
Calendar =
VAR MinDate =
    MIN ( 'FactOrderDetails'[OrderDate] )
VAR MaxDate =
    MAX ( 'FactOrderDetails'[OrderDate] )
VAR BaseCalendar =
    CALENDAR ( MinDate, MaxDate )
RETURN
    ADDCOLUMNS (
        BaseCalendar,
        "Year", YEAR ( [Date] ),
        "Month Num", MONTH ( [Date] ),
        "Month", FORMAT ( [Date], "MMMM" ),
        "Day Num", WEEKDAY ( [Date], 2 ),
        "Day", FORMAT ( [Date], "DDDD" ),
        "Quarter", "Q-" & QUARTER ( [Date] ),
        "YearMonth", FORMAT ( [Date], "YYYY-MM" )
    )
```
### DAX Measures: Turning Raw Data Into Insight
With the model structure in place, it was time to bring the numbers to life. This is where DAX came in not just to do math, but to answer the real questions we’d laid out earlier.

I started by building the core metrics you'd expect in any sales report:














