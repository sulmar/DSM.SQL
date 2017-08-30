

/* ZADANIE #1
Utw�rz zestawienie, kt�re poka�e 
ilo�� i sum� zam�wie� (SubTotal) 
w podziale na klient�w.
(na podst. tabeli Sales.SalesOrderHeader)

przyk�ad:

CustomerId | Qty | Total
11001	   |  39 | 200
11004	   |  15 |  10
11002	   |  65 | 190

*/


/* ZADANIE #2
Posortuj wyniki z zadania #1 wg kolumny Total
od najwi�kszej do namniejszej warto�ci 


przyk�ad:

CustomerId | Qty | Total
11001	   |  39 | 200
11002	   |  65 | 190
11004	   |  15 |  10

*/



/* ZADANIE #3
Wy�wietl tylko tych klient�w z zadania #2
w kt�rych ilo�� zam�wie� przekracza 10


przyk�ad:

CustomerId | Qty | Total
11001	   |  39 | 200
11002	   |  65 | 190

*/

/*
Wy�wietl zestawienie z zadania #3 ale tylko na rok 2014

przyk�ad:

CustomerId | Qty | Total
11001	   |  19 | 120
11002	   |  35 | 70

*/


-- Z��CZENIA

use AdventureWorks2014


-- z��czenie wewn�trzne

/*
 Wy�wietl zestawienie o podanej strukturze:

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

-- aliasy tabel (bez u�ycia as)
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
kolejno�� przetwarzania zapytania:
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
	Zsumowa� zam�wienia na podstawie pozycji zam�wie�
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

-- agregacja danych na podstawie z��czonych tabel
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

-- tworzenie kolumny wyliczeniowej na przyk�adzie iloczynu
select 
	OrderQty,
	UnitPrice,
	OrderQty * UnitPrice as Total	 
from 
	Sales.SalesOrderDetail
		
-- agregacja danych na podstawie z��czonych tabel + obliczanie iloczynu w locie
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


-- lewe z��czenie zewn�trzne

select 
	p.Name as [Product Name],
	pm.Name as [Product Model Name]	
from Production.Product as p
	left outer join Production.ProductModel as pm
		on p.ProductModelID = pm.ProductModelID

-- prawe z��czenie zewn�trzne

select 
	p.Name as [Product Name],
	pm.Name as [Product Model Name]	
from Production.Product as p
	right outer join Production.ProductModel as pm
		on p.ProductModelID = pm.ProductModelID

-- pe�ne z��czenie zewn�trzne

select 
	p.Name as [Product Name],
	pm.Name as [Product Model Name]	
from Production.Product as p
	full outer join Production.ProductModel as pm
		on p.ProductModelID = pm.ProductModelID
where 
	p.Name is null

-- zast�pienie warto�ci null inn� warto�ci�
select 
	isnull(ProductModelID, 0) as ProductModelID
from Production.Product


-- zast�pienie warto�ci null pustym tekstem
select 
	p.Name as [Product Name],
	isnull(pm.Name, '') as [Product Model Name]	
from Production.Product as p
	full outer join Production.ProductModel as pm
		on p.ProductModelID = pm.ProductModelID


-- Z��czenie tabel z r�nych baz danych
select * from Sales.Customer as c
inner join AdventureWorks.Sales.Customer as c2
	on c.CustomerID  = c2.CustomerID


-- unikalne warto�ci

select distinct Color from Production.Product

-- wyszukiwanie po fragmencie tekstu

-- znajd� produkty, kt�rych numer rozpoczyna si� od CR
select * from Production.Product
where ProductNumber like 'CR%'


select * from Production.Product
where ProductNumber like 'CR___'

-- znajd� produkty, kt�rych nazwa zawiera s�owo "Nut"
select * from Production.Product
where Name like '%Nut%'+

