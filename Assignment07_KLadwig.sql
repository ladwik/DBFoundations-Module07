--*************************************************************************--
-- Title: Assignment07
-- Author: KLadwig
-- Desc: This file demonstrates how to use Functions
-- Change Log: When,Who,What
-- 2017-01-01,RRoot,Created File
-- 2022-08-23,KLadwig,Answered Questions 1-3
-- 2022-08-25,KLadwig,Answered Question 4-8
-- 2022-08-27,KLadwig,Completed File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment07DB_KLadwig')
	 Begin 
	  Alter Database [Assignment07DB_KLadwig] set Single_user With Rollback Immediate;
	  Drop Database Assignment07DB_KLadwig;
	 End
	Create Database Assignment07DB_KLadwig;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment07DB_KLadwig;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL
,[ProductID] [int] NOT NULL
,[ReorderLevel] int NOT NULL -- New Column 
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count], [ReorderLevel]) -- New column added this week
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock, ReorderLevel
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10, ReorderLevel -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, abs(UnitsInStock - 10), ReorderLevel -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go


-- Adding Views (Module 06) -- 
Create View vCategories With SchemaBinding
 AS
  Select CategoryID, CategoryName From dbo.Categories;
go
Create View vProducts With SchemaBinding
 AS
  Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go
Create View vEmployees With SchemaBinding
 AS
  Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go
Create View vInventories With SchemaBinding 
 AS
  Select InventoryID, InventoryDate, EmployeeID, ProductID, ReorderLevel, [Count] From dbo.Inventories;
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From vCategories;
go
Select * From vProducts;
go
Select * From vEmployees;
go
Select * From vInventories;
go

/********************************* Questions and Answers *********************************/
Print
'NOTES------------------------------------------------------------------------------------ 
 1) You must use the BASIC views for each table.
 2) Remember that Inventory Counts are Randomly Generated. So, your counts may not match mine
 3) To make sure the Dates are sorted correctly, you can use Functions in the Order By clause!
------------------------------------------------------------------------------------------'
-- Question 1 (5% of pts):
-- Show a list of Product names and the price of each product.
-- Use a function to format the price as US dollars.
-- Order the result by the product name.

-- <Put Your Code Here> --
/* Notes:
1/ View data
SELECT * FROM vProducts;

2/ List columns
SELECT ProductName
    ,UnitPrice
FROM vProducts;

3/ Add FORMAT function and ORDER BY
SELECT ProductName
    ,FORMAT(UnitPrice,'C','en-us') AS UnitPrice
FROM vProducts
ORDER BY ProductName ASC;
*/

-- Q1 Answer:
SELECT ProductName
    ,FORMAT(UnitPrice,'C','en-us') AS UnitPrice
FROM vProducts
ORDER BY ProductName ASC;
GO

-- Question 2 (10% of pts): 
-- Show a list of Category and Product names, and the price of each product.
-- Use a function to format the price as US dollars.
-- Order the result by the Category and Product.
-- <Put Your Code Here> --
/* Notes
1/ View data
SELECT * FROM vProducts;
SELECT * FROM vCategories;

2/ List columns
SELECT ProductName
    ,UnitPrice
FROM vProducts;

SELECT CategoryName
FROM vCategories;

3/ JOIN tables on CategoryID
SELECT C.CategoryName
    ,P.ProductName
    ,P.UnitPrice
FROM vProducts P
INNER JOIN vCategories C
    ON P.CategoryID = C.CategoryID;

4/ Add FORMAT function and ORDER BY
SELECT C.CategoryName
    ,P.ProductName
    ,FORMAT(UnitPrice,'C','en-us') AS UnitPrice
FROM vProducts P
INNER JOIN vCategories C
    ON P.CategoryID = C.CategoryID
ORDER BY c.CategoryName ASC
    ,P.ProductName ASC;
*/

-- Q2 Answer:
SELECT C.CategoryName
    ,P.ProductName
    ,FORMAT(UnitPrice,'C','en-us') AS UnitPrice
FROM vProducts P
INNER JOIN vCategories C
    ON P.CategoryID = C.CategoryID
ORDER BY c.CategoryName ASC
    ,P.ProductName ASC;
GO

-- Question 3 (10% of pts): 
-- Use functions to show a list of Product names, each Inventory Date, and the Inventory Count.
-- Format the date like 'January, 2017'.
-- Order the results by the Product and Date.

-- <Put Your Code Here> --
/* Notes
1/ View data
SELECT * FROM vProducts;
SELECT * FROM vInventories;

2/ List columns
SELECT ProductName
FROM vProducts;

SELECT InventoryDate
    ,Count
FROM vInventories;

3/ JOIN tables on ProductID
SELECT P.ProductName
    ,I.InventoryDate
    ,I.Count
FROM vProducts P
INNER JOIN vInventories I
    ON P.ProductID = I.ProductID;

4/ Add DATE functions
SELECT P.ProductName
    ,I.InventoryDate
    ,DATENAME(mm,I.InventoryDate)
    ,YEAR(I.InventoryDate)
    ,I.Count
FROM vProducts P
INNER JOIN vInventories I
    ON P.ProductID = I.ProductID;

5/ Add CONCAT function and ORDER BY
SELECT P.ProductName
    ,CONCAT(DATENAME(mm,I.InventoryDate),', ',YEAR(I.InventoryDate)) AS Date
    ,I.Count
FROM vProducts P
INNER JOIN vInventories I
    ON P.ProductID = I.ProductID
ORDER BY P.ProductName ASC
    ,I.InventoryDate ASC;
*/

-- Q3 Answer:
SELECT P.ProductName
    ,CONCAT(DATENAME(mm,I.InventoryDate),', ',YEAR(I.InventoryDate)) AS InventoryDate
    ,I.Count AS InventoryCount
FROM vProducts P
INNER JOIN vInventories I
    ON P.ProductID = I.ProductID
ORDER BY P.ProductName ASC
    ,I.InventoryDate ASC;
GO

-- Question 4 (10% of pts): 
-- CREATE A VIEW called vProductInventories. 
-- Shows a list of Product names, each Inventory Date, and the Inventory Count. 
-- Format the date like 'January, 2017'.
-- Order the results by the Product and Date.

-- <Put Your Code Here> --
/* Notes
1/ View data
SELECT * FROM vProducts;
SELECT * FROM vInventories;

2/ List columns
SELECT ProductName
FROM vProducts;

SELECT InventoryDate
    ,Count
FROM vInventories;

3/ JOIN tables on ProductID
SELECT P.ProductName
    ,I.InventoryDate
    ,I.Count
FROM vProducts P
INNER JOIN vInventories I
    ON P.ProductID = I.ProductID;

4/ Add DATE functions
SELECT P.ProductName
    ,I.InventoryDate
    ,DATENAME(mm,I.InventoryDate)
    ,YEAR(I.InventoryDate)
    ,I.Count
FROM vProducts P
INNER JOIN vInventories I
    ON P.ProductID = I.ProductID;

5/ Add CONCAT function
SELECT P.ProductName
    ,CONCAT(DATENAME(mm,I.InventoryDate),', ',YEAR(I.InventoryDate)) AS Date
    ,I.Count
FROM vProducts P
INNER JOIN vInventories I
    ON P.ProductID = I.ProductID;

6/ Add CREATE VIEW, TOP, and ORDER BY Clauses
CREATE VIEW vProductInventories
AS
    SELECT TOP 10000000
        ,P.ProductName
        ,CONCAT(DATENAME(mm,I.InventoryDate),', ',YEAR(I.InventoryDate)) AS Date
        ,I.Count
    FROM vProducts P
    INNER JOIN vInventories I
        ON P.ProductID = I.ProductID
    ORDER BY P.ProductName ASC
        ,I.InventoryDate ASC;
*/

-- Q4 Answer:
CREATE VIEW vProductInventories
AS
    SELECT TOP 10000000
        P.ProductName
        ,CONCAT(DATENAME(mm,I.InventoryDate),', ',YEAR(I.InventoryDate)) AS InventoryDate
        ,I.Count AS InventoryCount
    FROM vProducts P
    INNER JOIN vInventories I
        ON P.ProductID = I.ProductID
    ORDER BY P.ProductName ASC
        ,I.InventoryDate ASC;
GO

-- Check that it works:
SELECT * FROM vProductInventories;
GO

-- Question 5 (10% of pts): 
-- CREATE A VIEW called vCategoryInventories. 
-- Shows a list of Category names, Inventory Dates, and a TOTAL Inventory Count BY CATEGORY
-- Format the date like 'January, 2017'.
-- Order the results by the Product and Date.

-- <Put Your Code Here> --
/* Notes
1/ View data
SELECT * FROM vCategories;
SELECT * FROM vProducts;
SELECT * FROM vInventories;

2/ Link Category and Inventory Tables by CategoryID and ProductID
SELECT *
FROM vProducts P
INNER JOIN vCategories C
    ON P.CategoryID = C.CategoryID
INNER JOIN vInventories I
    ON P.ProductID = I.ProductID;

3/ Select Columns
SELECT C.CategoryName
    ,InventoryDate
    ,Count
FROM vProducts P
INNER JOIN vCategories C
    ON P.CategoryID = C.CategoryID
INNER JOIN vInventories I
    ON P.ProductID = I.ProductID;

4/ Add SUM function, CONCAT function, andGROUP BY clause
SELECT C.CategoryName
    ,CONCAT(DATENAME(mm,I.InventoryDate),', ',YEAR(I.InventoryDate)) AS InventoryDate
    ,SUM(I.Count) AS InventoryCountByCategory
FROM vProducts P
INNER JOIN vCategories C
    ON P.CategoryID = C.CategoryID
INNER JOIN vInventories I
    ON P.ProductID = I.ProductID
GROUP BY C.CategoryName
    ,I.InventoryDate;

5/ Add CREATE VIEW, TOP, and ORDER BY Clauses
CREATE VIEW vCategoryInventories
AS 
    SELECT TOP 10000000
        C.CategoryName
        ,CONCAT(DATENAME(mm,I.InventoryDate),', ',YEAR(I.InventoryDate)) AS InventoryDate
        ,SUM(I.Count) AS InventoryCountByCategory
    FROM vProducts P
    INNER JOIN vCategories C
        ON P.CategoryID = C.CategoryID
    INNER JOIN vInventories I
        ON P.ProductID = I.ProductID
    GROUP BY C.CategoryName
        ,I.InventoryDate
    ORDER BY C.CategoryName
        ,I.InventoryDate;
*/

-- Q5 Answer:
CREATE VIEW vCategoryInventories
AS 
    SELECT TOP 10000000
        C.CategoryName
        ,CONCAT(DATENAME(mm,I.InventoryDate),', ',YEAR(I.InventoryDate)) AS InventoryDate
        ,SUM(I.Count) AS InventoryCountByCategory
    FROM vProducts P
    INNER JOIN vCategories C
        ON P.CategoryID = C.CategoryID
    INNER JOIN vInventories I
        ON P.ProductID = I.ProductID
    GROUP BY C.CategoryName
        ,I.InventoryDate
    ORDER BY C.CategoryName
        ,I.InventoryDate;
GO

-- Check that it works:
SELECT * FROM vCategoryInventories;
GO

-- Question 6 (10% of pts): 
-- CREATE ANOTHER VIEW called vProductInventoriesWithPreviouMonthCounts. 
-- Show a list of Product names, Inventory Dates, Inventory Count, AND the Previous Month Count.
-- Use functions to set any January NULL counts to zero. 
-- Order the results by the Product and Date. 
-- This new view must use your vProductInventories view.

-- <Put Your Code Here> --
/* Notes
1/ View data
SELECT * FROM vProductInventories;

2/ Select Coulmns and add LAG function
SELECT ProductName
    ,InventoryDate
    ,InventoryCount
    ,LAG(InventoryCount,1,0) OVER (PARTITION BY 
        ProductName 
        ORDER BY ProductName
        ,MONTH(InventoryDate)) AS PreviousMonthCount
FROM vProductInventories;

3/ Add CREATE VIEW, TOP, and ORDER BY Clauses
CREATE VIEW vProductInventoriesWithPreviouMonthCounts
AS
    SELECT TOP 10000000
        ProductName
        ,InventoryDate
        ,InventoryCount
        ,LAG(InventoryCount,1,0) OVER (PARTITION BY 
            ProductName 
            ORDER BY ProductName ASC
            ,MONTH(InventoryDate) ASC) AS PreviousMonthCount
    FROM vProductInventories
    ORDER BY ProductName ASC
        ,MONTH(InventoryDate) ASC;
*/

-- Q6 Answer:
CREATE VIEW vProductInventoriesWithPreviouMonthCounts
AS
    SELECT TOP 10000000
        ProductName
        ,InventoryDate
        ,InventoryCount
        ,LAG(InventoryCount,1,0) OVER (PARTITION BY 
            ProductName 
            ORDER BY ProductName ASC
            ,MONTH(InventoryDate) ASC) AS PreviousMonthCount
    FROM vProductInventories
    ORDER BY ProductName ASC
        ,MONTH(InventoryDate) ASC;
GO

-- Check that it works:
SELECT * FROM vProductInventoriesWithPreviouMonthCounts;
GO

-- Question 7 (15% of pts): 
-- CREATE a VIEW called vProductInventoriesWithPreviousMonthCountsWithKPIs.
-- Show columns for the Product names, Inventory Dates, Inventory Count, Previous Month Count. 
-- The Previous Month Count is a KPI. The result can show only KPIs with a value of either 1, 0, or -1. 
-- Display months with increased counts as 1, same counts as 0, and decreased counts as -1. 
-- Varify that the results are ordered by the Product and Date.

-- <Put Your Code Here> --

-- Important: This new view must use your vProductInventoriesWithPreviousMonthCounts view!
-- Check that it works: Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs;
/* Notes
1/ View data
SELECT * FROM vProductInventoriesWithPreviouMonthCounts;

2/ SELECT columns and add CASE function
SELECT ProductName
    ,InventoryDate
    ,InventoryCount
    ,PreviousMonthCount
    ,CASE WHEN InventoryCount < PreviousMonthCount THEN -1
        WHEN InventoryCount = PreviousMonthCount THEN 0
        WHEN InventoryCount > PreviousMonthCount THEN 1
        ELSE 0 END AS CountVsPreviousCountKPI
FROM vProductInventoriesWithPreviouMonthCounts;

3/ Add CREATE VIEW, TOP, and ORDER BY Clauses
CREATE VIEW vProductInventoriesWithPreviousMonthCountsWithKPIs
AS
    SELECT TOP 10000000
        ProductName
        ,InventoryDate
        ,InventoryCount
        ,PreviousMonthCount
        ,CASE WHEN InventoryCount < PreviousMonthCount THEN -1
            WHEN InventoryCount = PreviousMonthCount THEN 0
            WHEN InventoryCount > PreviousMonthCount THEN 1
            ELSE 0 END AS CountVsPreviousCountKPI
    FROM vProductInventoriesWithPreviouMonthCounts
    ORDER BY ProductName
        ,MONTH(InventoryDate);
GO

SELECT * FROM vProductInventoriesWithPreviousMonthCountsWithKPIs;
*/

-- Q7 Answer:
CREATE VIEW vProductInventoriesWithPreviousMonthCountsWithKPIs
AS
    SELECT TOP 10000000
        ProductName
        ,InventoryDate
        ,InventoryCount
        ,PreviousMonthCount
        ,CASE WHEN InventoryCount < PreviousMonthCount THEN -1
            WHEN InventoryCount = PreviousMonthCount THEN 0
            WHEN InventoryCount > PreviousMonthCount THEN 1
            ELSE 0 END AS CountVsPreviousCountKPI
    FROM vProductInventoriesWithPreviouMonthCounts
    ORDER BY ProductName
        ,MONTH(InventoryDate);
GO

SELECT * FROM vProductInventoriesWithPreviousMonthCountsWithKPIs;
GO

-- Question 8 (25% of pts): 
-- CREATE a User Defined Function (UDF) called fProductInventoriesWithPreviousMonthCountsWithKPIs.
-- Show columns for the Product names, Inventory Dates, Inventory Count, the Previous Month Count. 
-- The Previous Month Count is a KPI. The result can show only KPIs with a value of either 1, 0, or -1. 
-- Display months with increased counts as 1, same counts as 0, and decreased counts as -1. 
-- The function must use the ProductInventoriesWithPreviousMonthCountsWithKPIs view.
-- Varify that the results are ordered by the Product and Date.

-- <Put Your Code Here> --

/* Notes
1/ View data
SELECT * FROM vProductInventoriesWithPreviousMonthCountsWithKPIs;

2/ SELECT columns
SELECT ProductName
    ,InventoryDate
    ,InventoryCount
    ,PreviousMonthCount
    ,CountVsPreviousCountKPI
FROM vProductInventoriesWithPreviousMonthCountsWithKPIs;

3/ Add CREATE FUNCTION
CREATE FUNCTION fProductInventoriesWithPreviousMonthCountsWithKPIs (
    @kpi INT
)
RETURNS TABLE
AS
RETURN
    SELECT ProductName
        ,InventoryDate
        ,InventoryCount
        ,PreviousMonthCount
        ,CountVsPreviousCountKPI
    FROM vProductInventoriesWithPreviousMonthCountsWithKPIs
    WHERE CountVsPreviousCountKPI = @kpi;
*/

-- Q8 Answer:
CREATE FUNCTION fProductInventoriesWithPreviousMonthCountsWithKPIs (
    @kpi INT
)
RETURNS TABLE
AS
RETURN
    SELECT ProductName
        ,InventoryDate
        ,InventoryCount
        ,PreviousMonthCount
        ,CountVsPreviousCountKPI
    FROM vProductInventoriesWithPreviousMonthCountsWithKPIs
    WHERE CountVsPreviousCountKPI = @kpi;
GO

-- Check that it works:
SELECT * FROM fProductInventoriesWithPreviousMonthCountsWithKPIs(1);
SELECT * FROM fProductInventoriesWithPreviousMonthCountsWithKPIs(0);
SELECT * FROM fProductInventoriesWithPreviousMonthCountsWithKPIs(-1);
GO

/***************************************************************************************/