use AdventureWorks2014

-- pojedyczny komentarz (1 linia)

/* komentarz w postaci bloku
 (wiele linii)
 */

-- wyœwietla wszystkie kolumny 
select * from Production.Product

-- wyœwietla okreœlone kolumny
select 
	Name, 
	ProductNumber, 
	Color, 
	StandardCost 
from 
	Production.Product

-- alias kolumn (zmiana nazwy kolumny)
-- (z u¿yciem s³owa kluczowego as )

select 
	Name as Nazwa, 
	ProductNumber as [Numer produktu], 
	Color as Kolor, 
	StandardCost as Koszt
from 
	Production.Product

-- alias kolumn (bez u¿ycia s³owa kluczowego as )
select 
	Name Nazwa, 
	ProductNumber [Numer produktu], 
	Color Kolor, 
	StandardCost Koszt
from 
	Production.Product



-- filtrowanie danych

select 
	ProductID [ID Produktu],
	Name Nazwa, 
	ProductNumber [Numer Produktu], 
	Color Kolor, 
	StandardCost Koszt 
from 
	Production.Product
where
	Color='Red'


-- wyszukanie wartoœci null
select 
	ProductID [ID Produktu],
	Name Nazwa, 
	ProductNumber [Numer Produktu], 
	Color Kolor, 
	StandardCost Koszt 
from 
	Production.Product
where
	Color is NULL

-- zastosowanie negacji
select 
	ProductID [ID Produktu],
	Name Nazwa, 
	ProductNumber [Numer Produktu], 
	Color Kolor, 
	StandardCost Koszt 
from 
	Production.Product
where
	Color is not NULL

-- operator AND (iloczyn logiczny)
select 
	ProductID [ID Produktu],
	Name Nazwa, 
	ProductNumber [Numer Produktu], 
	Color Kolor, 
	StandardCost Koszt 
from 
	Production.Product
where
	Color = 'Black' and StandardCost>50


-- operator OR (suma logiczna)
select 
	ProductID [ID Produktu],
	Name Nazwa, 
	ProductNumber [Numer Produktu], 
	Color Kolor, 
	StandardCost Koszt 
from 
	Production.Product
where
	Color='Black' or Color='Blue'
	
-- zastosowanie operatora IN i zbioru
select 
	ProductID [ID Produktu],
	Name Nazwa, 
	ProductNumber [Numer Produktu], 
	Color Kolor, 
	StandardCost Koszt 
from 
	Production.Product
where
	Color in ('Black','Blue','White')


-- SORTOWANIE

-- sortowanie narastaj¹co
select 
	ProductID,
	Name, 
	ProductNumber, 
	Color,
	StandardCost
from 
	Production.Product
order by 
	StandardCost

-- sortowanie malej¹co
select 
	ProductID,
	Name, 
	ProductNumber, 
	Color,
	StandardCost
from 
	Production.Product
order by 
	StandardCost desc


-- sortowanie po kilku kolumnach

select 
	ProductID,
	Name, 
	ProductNumber, 
	Color,
	StandardCost
from 
	Production.Product
order by 
	Color, StandardCost


-- AGREGACJA DANYCH

-- licznoœæ 
select 
	count(personID) AS ilosc
from 
	sales.Customer

-- suma
select  
	sum (SubTotal) as suma
from
	Sales.SalesOrderHeader

-- obliczanie wielu agregatów
select 
	count(*) as ilosc,
	sum(subtotal) as suma,
	AVG(SubTotal) as srednia,
	min(SubTotal) as minimum,
	max(subtotal) as maximum
from
	Sales.SalesOrderHeader
where
	year(OrderDate)=2012

-- grupowanie 

select
	TerritoryID,
	sum(subtotal) as suma,
	count(*) as [liczba zamowien]
from
	Sales.SalesOrderHeader

group by 
	TerritoryID


-- sortowanie po zagregowanej kolumnie

select
	TerritoryID,
	count(*) as [liczba zamowien]
from
	Sales.SalesOrderHeader

group by 
	TerritoryID
order by [liczba zamowien]

-- filtrowanie agregatów

select
	TerritoryID,
	count(*) as [liczba zamowien]
from
	Sales.SalesOrderHeader

group by 
	TerritoryID
having 
	count(*)>1000




/* ZADANIE #1
Utwórz zestawienie, które poka¿e 
iloœæ i sumê zamówieñ (SubTotal) 
w podziale na klientów.

CustomerId | Qty | Total
11001	   |  39 | 200
11002	   |  65 | 190

*/


/* ZADANIE #2
Posortuj wyniki z zadania #1 wg kolumny Total
od najwiêkszej do namniejszej wartoœci 
*/



/* ZADANIE #3
Wyœwietl tylko tych klientów gdzie iloœæ zamówieñ
przekracza 10
*/




