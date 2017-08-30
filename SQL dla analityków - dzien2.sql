

/* ZADANIE #1
Utwórz zestawienie, które poka¿e 
iloœæ i sumê zamówieñ (SubTotal) 
w podziale na klientów.
(na podst. tabeli Sales.SalesOrderHeader)

przyk³ad:

CustomerId | Qty | Total
11001	   |  39 | 200
11004	   |  15 |  10
11002	   |  65 | 190

*/


/* ZADANIE #2
Posortuj wyniki z zadania #1 wg kolumny Total
od najwiêkszej do namniejszej wartoœci 


przyk³ad:

CustomerId | Qty | Total
11001	   |  39 | 200
11002	   |  65 | 190
11004	   |  15 |  10

*/



/* ZADANIE #3
Wyœwietl tylko tych klientów z zadania #2
w których iloœæ zamówieñ przekracza 10


przyk³ad:

CustomerId | Qty | Total
11001	   |  39 | 200
11002	   |  65 | 190

*/

/*
Wyœwietl zestawienie z zadania #3 ale tylko na rok 2014

przyk³ad:

CustomerId | Qty | Total
11001	   |  19 | 120
11002	   |  35 | 70

*/


-- Z£¥CZENIA

use AdventureWorks2014


-- z³¹czenie wewnêtrzne

/*
 Wyœwietl zestawienie o podanej strukturze:

| AccountNumber | SalesOrderNumber | OrderDate
*/

select 
	SalesOrderHeader.CustomerID, 
	Customer.AccountNumber,
	Customer.PersonID,
	SalesOrderNumber, 
	OrderDate 
from 
	Sales.SalesOrderHeader
	inner join Sales.Customer
		on Sales.SalesOrderHeader.CustomerID = Sales.Customer.CustomerID




/*
 | Product Name | Color | OrderQty | LineTotal | 
*/

select
	Sales.SalesOrderDetail.ProductID, 
	Production.Product.Name,
	Production.Product.Color,
	Sales.SalesOrderDetail.OrderQty,
	Sales.SalesOrderDetail.LineTotal
from Sales.SalesOrderDetail
inner join Production.Product	
	on Sales.SalesOrderDetail.ProductID = Production.Product.ProductID


-- aliasy tabel
select
	sod.ProductID, 
	p.Name,
	p.Color,
	sod.OrderQty,
	sod.LineTotal
from Sales.SalesOrderDetail as sod
inner join Production.Product as p
	on sod.ProductID = p.ProductID

-- aliasy tabel (bez u¿ycia as)
select
	sod.ProductID, 
	p.Name,
	p.Color,
	sod.OrderQty,
	sod.LineTotal
from Sales.SalesOrderDetail sod
inner join Production.Product p
	on sod.ProductID = p.ProductID




select
	Sales.SalesOrderDetail.ProductID, 
	Name,
	Color,
	OrderQty,
	LineTotal
from Sales.SalesOrderDetail
inner join Production.Product	
	on Sales.SalesOrderDetail.ProductID = Production.Product.ProductID








/*
kolejnoœæ przetwarzania zapytania:
	5. SELECT 
	1. FROM
	2. WHERE
	3. GROUP BY
	4. HAVING
	6. ORDER BY
*/


select 
	CustomerId,
	SalesPersonID,
	*
from Sales.SalesOrderHeader

select * from HumanResources.Employee

/*
| SalesOrderNumber | OrderDate | Customer Account Number | Login |
*/

select * from Sales.SalesOrderHeader


select 
	SalesOrderNumber,
	OrderDate,
	c.AccountNumber as [Customer Account Number],
	e.LoginID
from 
	Sales.SalesOrderHeader as soh
	inner join Sales.Customer as c
		on soh.CustomerID = c.CustomerID
	inner join HumanResources.Employee as e
		on soh.SalesPersonID = e.BusinessEntityID


/*  
	Zsumowaæ zamówienia na podstawie pozycji zamówieñ
*/

select count(*) from Sales.SalesOrderHeader
select count(*) from Sales.SalesOrderDetail


select 
	* 
from 
	Sales.SalesOrderHeader as soh
	inner join Sales.SalesOrderDetail as sod
		on soh.SalesOrderID = sod.SalesOrderID

/* 
| SalesOrderNumber | OrderDate | Total
*/

-- agregacja danych na podstawie z³¹czonych tabel
select 
	soh.SalesOrderNumber,
	soh.OrderDate,
	sum(sod.LineTotal) as Total 
from 
	Sales.SalesOrderHeader as soh
	inner join Sales.SalesOrderDetail as sod
		on soh.SalesOrderID = sod.SalesOrderID
group by
	soh.SalesOrderNumber, soh.OrderDate

-- tworzenie kolumny wyliczeniowej na przyk³adzie iloczynu
select 
	OrderQty,
	UnitPrice,
	OrderQty * UnitPrice as Total	 
from 
	Sales.SalesOrderDetail
		
-- agregacja danych na podstawie z³¹czonych tabel + obliczanie iloczynu w locie
select 
	soh.SalesOrderNumber,
	soh.OrderDate,
	sum(sod.OrderQty * sod.UnitPrice) as Total,
	count(sod.SalesOrderID) as Number
from 
	Sales.SalesOrderHeader as soh
	inner join Sales.SalesOrderDetail as sod
		on soh.SalesOrderID = sod.SalesOrderID
group by
	soh.SalesOrderNumber, soh.OrderDate	
order by 
	Total desc


/*
| Product Name | Model Name |
*/

select 
	p.Name as [Product Name],
	pm.Name as [Product Model Name]	
from Production.Product as p
	inner join Production.ProductModel as pm
		on p.ProductModelID = pm.ProductModelID


-- lewe z³¹czenie zewnêtrzne

select 
	p.Name as [Product Name],
	pm.Name as [Product Model Name]	
from Production.Product as p
	left outer join Production.ProductModel as pm
		on p.ProductModelID = pm.ProductModelID

-- prawe z³¹czenie zewnêtrzne

select 
	p.Name as [Product Name],
	pm.Name as [Product Model Name]	
from Production.Product as p
	right outer join Production.ProductModel as pm
		on p.ProductModelID = pm.ProductModelID

-- pe³ne z³¹czenie zewnêtrzne

select 
	p.Name as [Product Name],
	pm.Name as [Product Model Name]	
from Production.Product as p
	full outer join Production.ProductModel as pm
		on p.ProductModelID = pm.ProductModelID
where 
	p.Name is null

-- zast¹pienie wartoœci null inn¹ wartoœci¹
select 
	isnull(ProductModelID, 0) as ProductModelID
from Production.Product


-- zastêpienie wartoœci null pustym tekstem
select 
	p.Name as [Product Name],
	isnull(pm.Name, '') as [Product Model Name]	
from Production.Product as p
	full outer join Production.ProductModel as pm
		on p.ProductModelID = pm.ProductModelID


-- Z³¹czenie tabel z ró¿nych baz danych
select * from Sales.Customer as c
inner join AdventureWorks.Sales.Customer as c2
	on c.CustomerID  = c2.CustomerID


-- unikalne wartoœci

select distinct Color from Production.Product

-- wyszukiwanie po fragmencie tekstu

-- znajdŸ produkty, których numer rozpoczyna siê od CR
select * from Production.Product
where ProductNumber like 'CR%'


select * from Production.Product
where ProductNumber like 'CR___'

-- znajdŸ produkty, których nazwa zawiera s³owo "Nut"
select * from Production.Product
where Name like '%Nut%'+

