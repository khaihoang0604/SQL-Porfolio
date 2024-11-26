USE AdventureWorksCycles
-- Retrieve the first 10 rows from the Sales.SalesOrderHeader table where the OrderDate is May 30, 2012.
SELECT TOP 10 *
FROM Sales.SalesOrderHeader
WHERE OrderDate = '2012-05-30'

-- Retrieve the first 10 rows from the Person.Person table where the MiddleName is not NULL.
SELECT TOP 10 *
FROM Person.Person
WHERE MiddleName IS NOT NULL

-- Retrieve all information from the Person.Person table where the PersonType is either 'SP' or 'GC'.
SELECT *
FROM Person.Person
WHERE PersonType = 'SP' OR PersonType = 'GC'

-- Retrieve the columns SalesOrderID, OrderDate, Status, and TotalDue from the Sales.SalesOrderHeader table where Freight is greater than 800.
SELECT 
    SalesOrderID
    , OrderDate
    , [Status]
    , TotalDue
FROM Sales.SalesOrderHeader
WHERE Freight > 800

/* Retrieve the columns BusinessEntityID, SalesQuota, SalesLastYear, and SalesYTD from the Sales.
SalesPerson table where Bonus is not 0 and SalesLastYear is greater than 0. */
SELECT 
    BusinessEntityID
    , SalesQuota
    , SalesLastYear
    , SalesYTD
FROM Sales.SalesPerson
WHERE Bonus <> 0 AND SalesLastYear > 0

/* Retrieve all information from the Purchasing.PurchaseOrderDetail table where the ReceivedQty is less than the OrderQty
, but no products have been rejected (RejectedQty is 0).*/
SELECT * 
FROM Purchasing.PurchaseOrderDetail
WHERE OrderQty > ReceivedQty AND RejectedQty = 0 

-- Retrieve all information from the Production.ProductSubcategory table where the Name contains the word 'bike'.
SELECT *
FROM Production.ProductSubcategory
WHERE NAME LIKE '%bike%'

-- Retrieve all information from the Production.Product table where the ProductNumber starts with 'T'.
SELECT *
FROM Production.Product
WHERE ProductNumber LIKE 'T%'

/* Retrieve the BusinessEntityID column and the Name column (created from the Title, FirstName, and LastName columns) 
from the Person.Person table, and the PhoneNumber column from the Person.PersonPhone table
, with the condition that Title is not NULL and PersonType is 'EM'. */
SELECT
    P.BusinessEntityID
    , Title + FirstName + LastName AS [Name] -- Null + value = Null
    , CONCAT(Title, '', FirstName, '', LastName) AS [Name]
    , CONCAT_WS('', Title, FirstName, LastName) AS [Name]
    , PhoneNumber
FROM Person.Person P, Person.PersonPhone PP
WHERE P.BusinessEntityID = PP.BusinessEntityID

/* Retrieve the ProductID, Name (renamed as Product Name), ProductNumber, Color, Size, and Weight columns
from the Production.Product table, and the Name column (renamed as Category Name) from the Production.
ProductCategory table, as well as the Name column (renamed as Product Subcat Name) from the Production.ProductSubcategory table. */
SELECT
    ProductID
    , P.Name AS [Product Name]
    , ProductNumber
    , C.Name AS [Category Name]
    , S.Name AS [Product Subcat Name]
    , Color
    , [Size]
    , Weight
FROM Production.Product P
    , Production.ProductSubcategory S
    , Production.ProductCategory C
WHERE P.ProductSubcategoryID = S.ProductSubcategoryID
    AND S.ProductCategoryID = C.ProductCategoryID

-- Retrieve the list of Group Name from the Department in the HumanResources.Department table.
SELECT DISTINCT GroupName
FROM HumanResources.Department

-- Retrieve the list of Department Name where the first letter is between M and Q.
SELECT Name
FROM HumanResources.Department
WHERE 
    Name BETWEEN 'M' AND 'R'

/* Retrieve the list of departments where the Department Name belongs to one of the following groups: 
Inventory Management, Quality Assurance, Manufacturing. Sort the results in descending order by name. */
SELECT * 
FROM HumanResources.Department
WHERE GroupName IN ('Inventory Management', 'Quality Assurance', 'Manufacturing')
ORDER BY GroupName DESC

-- Retrieve the list of BusinessEntityID that have 2 addresses.
SELECT 
    P.BusinessEntityID
    , A.AddressLine1
    , A.AddressLine2
    , A.City
    , A.StateProvinceID
    , A.PostalCode
FROM Person.BusinessEntityAddress P, Person.Address A
WHERE 
    P.AddressID = A.AddressID
    AND A.AddressLine1 IS NOT NULL
    AND A.AddressLine2 IS NOT NULL

/* Retrieve the list of columns:
BusinessEntityID, Person Name (created from FirstName, MiddleName, and LastName),
PersonType from the Person.Person table,
AddressLine1, City, PostalCode from the Person.Address table,
Address Type Name from the Person.AddressType table,
where the Address Type Name is not 'Home'. */
SELECT
    P.BusinessEntityID
    , CONCAT_WS(P.FirstName, P.MiddleName, P.LastName) AS [Person Name]
    , P.PersonType
    , A.AddressLine1
    , A.City
    , A.PostalCode
    , T.Name AS [Address Type]
FROM Person.Person P
    LEFT JOIN Person.BusinessEntityAddress PA ON P.BusinessEntityID = PA.BusinessEntityID
    LEFT JOIN Person.Address A ON PA.AddressID = A.AddressID
    LEFT JOIN Person.AddressType T ON PA.AddressTypeID = T.AddressTypeID
WHERE T.Name <> 'HOME'

-- Retrieve the list of products that have never been purchased.
SELECT P.*
FROM Production.Product P
    LEFT JOIN Sales.SalesOrderDetail D ON D.ProductID = P.ProductID
WHERE D.SalesOrderDetailID IS NULL

-- Retrieve the list of sales employees who did not have any sales in the previous year.
SELECT P.*
FROM Person.Person P
    INNER JOIN Sales.SalesPerson SP ON P.BusinessEntityID = SP.BusinessEntityID
WHERE SP.SalesLastYear = 0

/* Retrieve the list of sales employee names with the following condition:
If (SalesYTD - SalesLastYear) is greater than 0, round (SalesYTD - SalesLastYear) to the nearest integer,
Otherwise, if (SalesYTD - SalesLastYear) is less than 0, replace it with a hyphen ('-'), and name the column Different. */
SELECT 
    BusinessEntityID
    , CASE 
        WHEN (SalesYTD - SalesLastYear) > 0 THEN STR(SalesYTD - SalesLastYear, 50)
        ELSE '-'
    END Difference
FROM 
    Sales.SalesPerson


SELECT 
    *
    , STR(SalesYTD - SalesLastYear, 50) AS Difference
FROM Sales.SalesPerson
WHERE (SalesYTD - SalesLastYear) > 0
UNION ALL
SELECT
    *
    , '-'
FROM Sales.SalesPerson
WHERE (SalesYTD - SalesLastYear) <= 0


SELECT
    SP.BusinessEntityID
    , CONCAT_WS(' ', P.FirstName, P.LastName) AS [PERSON NAME]
    , CAST(ROUND((SalesYTD - SalesLastYear), 0) AS NVARCHAR(20)) AS [Different]
FROM Sales.SalesPerson SP
    INNER JOIN Person.Person P ON SP.BusinessEntityID = P.BusinessEntityID
WHERE (SalesYTD - SalesLastYear) > 0
UNION
SELECT  
    SP.BusinessEntityID
    , CONCAT_WS(' ', P.FirstName, P.LastName) AS [PERSON NAME]
    , ' - '
FROM Sales.SalesPerson SP
    INNER JOIN Person.Person P ON SP.BusinessEntityID = P.BusinessEntityID
WHERE (SalesYTD - SalesLastYear) < 0
ORDER BY Different

/* Retrieve the list of PurchaseOrderID, OrderDate, and ShipDate, and if the difference between OrderDate 
and ShipDate is less than 10 days, the Status should be 'Early', otherwise it should be 'Late'. */
SELECT
    POH.PurchaseOrderID
    , POH.OrderDate
    , POH.ShipDate
    , CASE
        WHEN DATEDIFF(DAY, POH.OrderDate, POH.ShipDate) < 10 THEN N'Early'
        ELSE N'Late'
    END AS 'STATUS'
FROM Purchasing.PurchaseOrderHeader POH

/* Retrieve the list of PurchaseOrderID, Status, EmployeeID, VendorID, and ShipMethodID.   
If Statusis 1, replace it with "Pending"
if 2, replace it with "Approved"
if 3, replace it with "Rejected"
if 4, replace it with "Complete"
And retrieve the rows whereShipMethodID` is 3 or 5. */
SELECT
    POH.PurchaseOrderID
    , POH.[Status]
    , POH.EmployeeID
    , POH.VendorID
    , CASE
        WHEN [Status] = 1 THEN 'Pending'
        WHEN [Status] = 2 THEN 'Approved'
        WHEN [Status] = 3 THEN 'Rejected'
        WHEN [Status] = 4 THEN 'Complete'
    END AS [Status Define]
    , POH.ShipMethodID
FROM Purchasing.PurchaseOrderHeader POH
WHERE ShipMethodID IN (3, 5)

/* Retrieve the list of PurchaseOrderID, Status, EmployeeID, VendorID, Freight, and ShipBase.  
If (Freight - ShipBase)is less than 10, setLevelas "Cheap" 
If(Freight - ShipBase)is between 10 and 50, setLevelas "Normal"
Otherwise, setLevel` as "High" */
SELECT
    POH.PurchaseOrderID
    , POH.[Status]
    , POH.EmployeeID
    , POH.VendorID
    , POH.Freight
    , SHIP.ShipBase
    , CASE
        WHEN (POH.Freight - SHIP.ShipBase) < 10 THEN N'Cheap'
        WHEN (POH.Freight - SHIP.ShipBase) BETWEEN 10 AND 50 THEN N'Normal'
        ELSE 'High'
    END AS [LEVEL]
FROM Purchasing.PurchaseOrderHeader POH, Purchasing.ShipMethod SHIP
WHERE POH.ShipMethodID = SHIP.ShipMethodID

/* Retrieve the list of PurchaseOrderID, (total OrderQty, total ReceivedQty, total RejectedQty, total quantity of each ProductID) 
for each PurchaseOrderID in the year 2014, where the total ReceivedQty is greater than 500 and the total OrderQty is greater than 1200. */
SELECT
    POD.PurchaseOrderID
    , SUM(OrderQty) AS TOTAL_ORDER_QTY
    , SUM(ReceivedQty) AS TOTAL_RECEIVED_QTY
    , SUM(RejectedQty) AS TOTAL_REJECTED_QTY
    , COUNT(ProductID) AS TOTAL_PRODUCT
FROM Purchasing.PurchaseOrderDetail POD
WHERE YEAR(DueDate) = 2014
GROUP BY POD.PurchaseOrderID
HAVING SUM(ReceivedQty) > 500 AND SUM(OrderQty) > 1200

/* Retrieve the list of (total OrderQty, total ReceivedQty, total RejectedQty, total quantity of each ProductID) 
for orders in the years 2013 and 2014 for each EmployeeID, where the total LineTotal for each employee in each year is greater than 500,000.
Sort the results by year and EmployeeID in descending order. */
SELECT
    YEAR(POH.OrderDate) AS YEAR_ORDERDATE
    , POH.EmployeeID
    , SUM(OrderQty) AS TOTAL_ORDER_QTY
    , SUM(ReceivedQty) AS TOTAL_RECEIVED_QTY
    , SUM(RejectedQty) AS TOTAL_REJECTED_QTY
    , COUNT(ProductID) AS TOTAL_PRODUCT
    --, SUM(LineTotal)
FROM Purchasing.PurchaseOrderDetail POD
    INNER JOIN Purchasing.PurchaseOrderHeader POH ON POD.PurchaseOrderID = POH.PurchaseOrderID
WHERE YEAR(DueDate) BETWEEN 2013 AND 2014
GROUP BY
    YEAR(POH.OrderDate)
    , POH.EmployeeID
HAVING SUM(LineTotal) > 500000
ORDER BY 1, 2

/* Retrieve the list of levels and the total TotalDue for each level. The levels are calculated as follows:
If (Freight - ShipBase) is less than 10, the level is 'Cheap'
If (Freight - ShipBase) is between 10 and 50, the level is 'Normal'
If (Freight - ShipBase) is greater than 50, the level is 'High'. */
SELECT
    CASE
        WHEN (POH.Freight - SHIP.ShipBase) < 10 THEN N'Cheap'
        WHEN (POH.Freight - SHIP.ShipBase) BETWEEN 10 AND 50 THEN N'Normal'
        ELSE 'High'
    END AS [LEVEL]
    , SUM(TotalDue) AS TotalDue
FROM Purchasing.PurchaseOrderHeader POH, Purchasing.ShipMethod SHIP
WHERE POH.ShipMethodID = SHIP.ShipMethodID
GROUP BY
    CASE
        WHEN (POH.Freight - SHIP.ShipBase) < 10 THEN N'Cheap'
        WHEN (POH.Freight - SHIP.ShipBase) BETWEEN 10 AND 50 THEN N'Normal'
        ELSE 'High'
    END
ORDER BY 2 DESC

/* Retrieve the list as shown in the table below. If AddressLine2 is NULL
, replace it with a hyphen ('-'), otherwise, keep AddressLine2 as it is.
Sort the results in descending order by AddressLine2 (from records with AddressLine2 to those without AddressLine2).*/
SELECT
    BusinessEntityID
    , AddressLine1
    , ISNULL(AddressLine2, '-') AS AddressLine2
    , City
    , StateProvinceID
    , PostalCode
FROM Person.BusinessEntityAddress P, Person.Address A
WHERE P.AddressID = A.AddressID
ORDER BY AddressLine2 DESC

/* Retrieve the list of ProductID where UnitPrice is between 700 and 1000
, UnitPriceDiscount is greater than 0.15, and LineTotal is greater than 1500 in the Sales.SalesOrderDetail table. 
Round UnitPrice to 2 decimal places. Only take the integer part of LineTotal, excluding the decimal part. 
Sort the results in ascending order by ProductID and descending order by LineTotal.*/
SELECT 
    S.ProductID
    , ROUND(S.UnitPrice, 2) AS UnitPrice
    , S.UnitPriceDiscount
    , CAST(S.LineTotal AS INT) AS LineTotal
FROM Sales.SalesOrderDetail S
WHERE 
    ROUND(UnitPrice, 2) BETWEEN 700 AND 1000
    AND UnitPriceDiscount > 0.15
    AND LineTotal > 1500
ORDER BY ProductID ASC, LineTotal DESC

/* Retrieve the list of Vendors from the Purchasing.Vendor table. If PurchasingWebServiceURL is not NULL
, keep it as is. Otherwise, replace it with the string structured as
www.Name.co/ (where Name should have spaces removed and be converted to lowercase).*/
SELECT
    BusinessEntityID
    , AccountNumber
    , Name
    , ISNULL(PurchasingWebServiceURL, CONCAT('www.', LOWER(REPLACE(Name, ' ', '')), '.co/')) AS PurchasingWebServiceURL
FROM Purchasing.Vendor;

/* Retrieve the list of invoice details where the time difference between OrderDate and ShipDate 
is less than 30, and the products belong to categories with the most subcategories. */
WITH
NUM_OF_SUBCAT AS
(
    SELECT
        ProductCategoryID
        , COUNT(ProductSubcategoryID) AS SL
    FROM Production.ProductSubcategory
    GROUP BY ProductCategoryID
)
, SUBCAT AS
(
    SELECT ProductSubcategoryID
    FROM Production.ProductSubcategory
    WHERE ProductCategoryID IN (
                                    SELECT ProductCategoryID
                                    FROM NUM_OF_SUBCAT
                                    WHERE SL= (SELECT MAX(SL) FROM NUM_OF_SUBCAT)
                                )
)
SELECT SOH.*
FROM Sales.SalesOrderHeader SOH
    INNER JOIN
    (
        SELECT DISTINCT SalesOrderID
        FROM Sales.SalesOrderDetail SOD
            INNER JOIN Production.Product P ON SOD.ProductID= P.ProductID
            INNER JOIN SUBCAT ON SUBCAT.ProductSubcategoryID= P.ProductSubcategoryID
    ) SOD ON SOH.SalesOrderID= SOD.SalesOrderID
WHERE DATEDIFF(DAY, OrderDate, ShipDate) < 30

/* Retrieve customer information and the time difference between the most recent purchase date 
and the current date (assuming the current date is the maximum date in the data table). */
SELECT
CustomerID
, DATEDIFF(DAY, MAX(OrderDate), (SELECT MAX(OrderDate) FROM Sales.SalesOrderHeader)) AS DATEDIFF
FROM Sales.SalesOrderHeader
GROUP BY CustomerID

/* Retrieve the list of products, the ListPrice of each product, the average UnitPrice of each product
, and a column More? determined by the following logic:
If ListPrice < average UnitPrice of the product, set as 'Yes'
If ListPrice > average UnitPrice of the product, set as 'No'
Otherwise, set as 'Equal' */
SELECT
    P.ProductID
    , P.ListPrice AS Price_in_Product
    , Sale.Price_in_Sale
    , CASE
        WHEN P.ListPrice < Sale.Price_in_Sale THEN 'YES'
        WHEN P.ListPrice > Sale.Price_in_Sale THEN 'NO'
        ELSE 'EQUAL'
      END AS [More?]
FROM Production.Product P
    INNER JOIN (
        SELECT
            ProductID
            , AVG(UnitPrice) AS Price_in_Sale
        FROM Sales.SalesOrderDetail
        GROUP BY ProductID
    ) AS Sale ON P.ProductID= Sale.ProductID
    