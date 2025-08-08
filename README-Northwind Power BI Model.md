# Building a Star Schema for Power BI Using SQL Views
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




























