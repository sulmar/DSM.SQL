# Podstawy języka SQL 

Z użyciem przykładowej bazy danych **Sakila**
https://github.com/ivanceras/sakila/tree/master/sql-server-sakila-db

### Wybór bazy danych

~~~ sql
use sakila
~~~

### Komentarze

- Komentarz pojedycznej linii
~~~ sql
-- komentarz
~~~

- Komentarz blokowy
~~~ sql
/* 
   komentarz
   blokowy
*/
~~~


### Pobranie danych z tabeli
~~~ sql
select * from customer
~~~ 

### Wybór pól

~~~ sql
select first_name, last_name, email from customer
~~~

### Aliasy kolumn
~~~ sql
select 
	first_name as imie, 
	last_name as nazwisko, 
	email
from 
	customer
~~~


### Filtrowanie

- Filtrowanie z uzyciem operatorów logicznych
~~~ sql
select 
	first_name as imie, 
	last_name as nazwisko, 
	email,
	active
from 
	customer
where
	(first_name = 'mary' or first_name = 'john' or first_name = 'adam')
	and active = 0
~~~

- Filtrowanie na podstawie zbioru
~~~ sql
select 
	first_name as imie, 
	last_name as nazwisko, 
	email,
	active
from 
	customer
where
	first_name in ('mary', 'john', 'adam')
~~~

## Sortowanie

- sortowanie po jednej kolumnie
~~~ sql
select * from customer order by first_name
~~~

- sortowanie po kilku kolumnach
~~~ sql
select * from customer order by first_name desc, last_name desc
~~~

## Funkcje tekstowe

- operacje na tekstach
~~~ sql
select 
	first_name,
	lower(first_name),
	left(first_name, 3), 
	right(last_name, 3),
	SUBSTRING(first_name, 3, 2)
from customer
~~~

## Funkcje agregujące

- liczność rekordów
~~~ sql
select count(*) from customer where active = 1
~~~

- liczność wartości
~~~ sql
select count(first_name) as quantity from customer where active = 1
~~~

- suma 
~~~ sql
select sum(amount) as total from payment
~~~


- ilość unikalnych
~~~ sql
select count(distinct first_name) from customer
~~~

- obliczanie średniej
~~~ sql
select avg(isnull(amount,0)) from payment
~~~

## Złączenia

- złączenie wewnętrzne (inner join)

~~~ sql
select 
	customer.first_name,
	customer.last_name,
	[address].[address],
	customer.address_id,
	[address].city_id
 from customer
	inner join address 
		on customer.address_id = address.address_id  -- warunek złączenia
~~~


- złączenie wielu tabel

~~~ sql
select 
	customer.first_name,
	customer.last_name,
	[address].[address],
	city.city,
	country.country
 from customer
	inner join address 
		on customer.address_id = address.address_id  -- warunek złączenia
	inner join city
		on address.city_id = city.city_id
	inner join country
		on city.country_id = country.country_id
~~~


- Ilość klientów w poszczególnych państwach

~~~ sql
select 
	country.country,
	count(*) as [count]
 from customer
	inner join address 
		on customer.address_id = address.address_id  -- warunek złączenia
	inner join city 
		on address.city_id = city.city_id
	inner join country 
		on city.country_id = country.country_id
group by country.country

~~~


- Wyświetlenie filmów i ich kategorii

~~~ sql
select 
	film.title,
	category.name
 from film
	inner join film_category
		on film.film_id = film_category.film_id
	inner join category
		on film_category.category_id = category.category_id
~~~


## Zadania

- Z jakiej kategorii najczęściej klienci wypożyczają filmy?

~~~ sql
select 
	category.name,
	count(*) as rent_count
 from rental
	 inner join inventory 
		on rental.inventory_id = inventory.inventory_id
     inner join film_category 
		on film_category.film_id = inventory.film_id
	inner join category
		on film_category.category_id = category.category_id
group by
	category.name
~~~


## Podzapytania
- podzapytanie

~~~ sql
select sum(rent_count) from 
(select 
	category.name,
	count(*) as rent_count
 from rental
	 inner join inventory 
		on rental.inventory_id = inventory.inventory_id
     inner join film_category 
		on film_category.film_id = inventory.film_id
	inner join category
		on film_category.category_id = category.category_id
group by
	category.name) as subquery

~~~ 


### Zadanie

- Który z aktorów najczęściej występuje w filmach?
~~~ sql
select top(1)
  actor.first_name,
  actor.last_name,
  count(*) as actor_count
from film
 inner join film_actor 
	on film.film_id = film_actor.film_id
 inner join actor
	on film_actor.actor_id = actor.actor_id
group by
	actor.first_name, actor.last_name
order by count(*) desc
~~~



- Które filmy generują największe przychody (top 10)?

~~~ sql
select 
	top(10)
	film.title,
	sum(payment.amount) as total
 from payment
	inner join rental
		on payment.rental_id = rental.rental_id
	inner join inventory
		on rental.inventory_id = inventory.inventory_id
    inner join film
		on inventory.film_id = film.film_id
group by film.title
order by total desc
~~~

- W jakim kraju, której kategorii najczęściej są wypożyczane filmy?


~~~ sql

select 
   cat.name,
   ctr.country,
   count(r.rental_id) as rent_count,
   sum(p.amount) as total
from rental as r
	inner join customer as c
		on r.customer_id = c.customer_id
	inner join address as a
		on c.address_id = a.address_id
	inner join city as ct
		on a.city_id = ct.city_id
	inner join country as ctr
		on ct.country_id = ctr.country_id
	inner join inventory as i
		on r.inventory_id = i.inventory_id
	inner join film as f
		on i.film_id = f.film_id
	inner join film_category as fc
		on fc.film_id = f.film_id
	inner join category as cat
		on cat.category_id = fc.category_id
	inner join payment as p
		on p.rental_id = r.rental_id
group by
   cat.name,
   ctr.country
order by
   cat.name,
   ctr.country,
   rent_count desc
~~~


- Jaki jest średni czas wypożyczenia filmów w poszczególnych kategoriach?

~~~ sql
select 
	category.name,
	avg(datediff(hour, rental_date, return_date) / 24.0) as averange 
from rental
	inner join inventory 
		on rental.inventory_id = inventory.inventory_id
	inner join film
		on inventory.film_id = film.film_id
	inner join film_category
		on film_category.film_id = film.film_id
	inner join category
		on film_category.category_id = category.category_id
group by category.name
~~~

## Modyfikacja danych

### Wstawienie danych

- Wstawienie pojedynczego rekordu
~~~ sql
insert into customer  
	values(1, 'MARCIN', 'SULECKI', 'marcin.sulecki@sulmar.pl', 605, 1, getdate(), getdate())
~~~

- Wstawienie wielu rekordów

~~~ sql
 -- wstawienie wielu rekordów
insert into city 
	values ('Poznań', 76, getdate()), 
		   ('Warszawa', 76, getdate()), 
		   ('Niepruszewo', 76, getdate())

~~~




### Zadanie
1. dodaj nową kategorię 'Educational'
~~~ sql
insert into category
	values('Educational', getdate())

~~~

1. dodaj nowy film np. 'SQL in Action' w kategorii 'Educational'
~~~ sql
insert into film (title, language_id, rental_duration, rental_rate, length, replacement_cost, last_update)
	values ('SQL in Action', 1, 5, 4.99, 120, 20, getdate())
~~~


1. dodaj 2 kopie filmu dla sklepu Store 1 i 1 kopię filmu do sklepu Store 2

~~~ sql
insert into inventory
	values (1002, 1, GETDATE()), (1002, 1, getdate()), (1002, 2, getdate())
~~~


1. Wypozycz film 'SQL in Action' ze sklepu Store 2

~~~ sql
insert into rental 
 values(getdate(), 4583, 599, null, 1, GETDATE())
~~~

1. Zwróć wypozyczony film
~~~ sql
update rental 
	 set return_date = GETDATE()
where
	rental_id = 16051
~~~


1. które z filmów są obecnie wypożyczone?

~~~ sql
select distinct
	film.title
from rental
	inner join inventory
		on rental.inventory_id = inventory.inventory_id
	inner join film
		on inventory.film_id = film.film_id
where
	rental.return_date is null 
~~~




~~~ sql

insert into inventory
	values (1002, 1, GETDATE()), (1002, 1, getdate()), (1002, 2, getdate())

~~~

## Złączenia zewnętrzne

### Lewe złączenie zewnętrzne

~~~ sql
select 
	rental.rental_date,
	rental.customer_id,
	customer.first_name,
	customer.last_name,
	customer.customer_id
from customer
	left outer join rental
		on rental.customer_id = customer.customer_id
~~~

### Prawe złączenie zewnętrzne

~~~ sql
select 
	rental.rental_date,
	rental.customer_id,
	customer.first_name,
	customer.last_name,
	customer.customer_id
from rental
	right outer join customer
		on rental.customer_id = customer.customer_id
~~~
- Zastosowanie

~~~ sql
select 
	customer.first_name,
	customer.last_name,
	count(rental.rental_id) as rent_count
from rental
	right outer join customer
		on rental.customer_id = customer.customer_id
group by customer.first_name, customer.last_name
order by rent_count 
~~~


### Pełne złączenie zewnętrzne

~~~ sql
select 
	rental.rental_date,
	rental.customer_id,
	customer.first_name,
	customer.last_name,
	customer.customer_id
from rental
	full outer join customer
		on rental.customer_id = customer.customer_id
~~~


## Zadanie

1. w ktorych 3 miastach mamy najwiecej klientow?
~~~ sql
select 
	top(3)
    city.city
from customer
	inner join address
		on customer.address_id = address.address_id
	inner join city
		on address.city_id = city.city_id
group by city.city
order by count(*) desc
~~~

2. w jakich miastach mamy sklepy?

## Suma zbiorów

- w jakich miastach mamy przeprowadzić akcję bilboardową? Na podst. 3 miast, w których mamy najwiecej klientów i lokalizacji sklepów.  

~~~ sql

select city from
(select 
	top(3)
    city.city
from customer
	inner join address
		on customer.address_id = address.address_id
	inner join city
		on address.city_id = city.city_id
group by city.city
order by count(*) desc) as city_of_customers

union

select distinct city.city from store	
	inner join address
		on store.address_id = address.address_id
	inner join city
		on address.city_id = city.city_id
 ~~~       



## Kolejność przetwarzania zapytania

- jakie filmy w jezyku angielskim wypozyczone byly wiecej niz 3 razy?

~~~ sql
select 
	film.title,
	count(rental.rental_id) as rental_count  
from rental
	inner join inventory 
		on rental.inventory_id = inventory.inventory_id
	inner join film
		on inventory.film_id = film.film_id
where film.language_id = 1
group by film.title
having COUNT(*) > 3
order by rental_count desc

~~~

- Kolejność

1. FROM
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT
6. ORDER BY



## Zadania

- jaki jest średni czas wypożyczenia filmów i dochód w podziale na kategorie?

~~~ sql
select 
	c.name,
	avg(datediff(day, rental.rental_date, rental.return_date)) as average,
	sum(p.amount) as total
from rental
	inner join inventory 
		on rental.inventory_id = inventory.inventory_id
	inner join film as f
		on f.film_id = inventory.film_id
	inner join film_category as fc
		on fc.film_id = f.film_id
	inner join category as c
		on c.category_id = fc.category_id
	inner join payment as p
		on p.rental_id = rental.rental_id
group by c.name
order by c.name		

~~~


- znajdz wszystkich klientów, którzy mają kod pocztowy zaczynający się od 30

~~~ sql
select 
	customer.first_name + ' ' + customer.last_name as fullname
 from address
	inner join customer 
		on address.address_id = customer.address_id
where address.postal_code like '30%'

~~~


## Tworzenie tabel

### Utworzenie tabeli

Utwórz tabelę finish_goods zawierającą następujące kolumny:
- finish_good_id (PK)
- code (10 znakow)
- name (do 40 znakow)

~~~ sql
create table dbo.finish_good 
(
	finish_good_id int not null primary key,
	code char(10) not null,
	name varchar(40) null
)
~~~

- Wypełnienie tabeli danymi

~~~ sql

insert into finish_good 
   values  
(1	, 'FA00357B05'	, 'Vitaminas A, D3, E y K1 premix  ' ),
(2	, 'FA00355P01'	, 'Premix Vit nutr med FT117002EU'),
(3	, 'FA00356B05'	, 'Premix Vit A, D3, E, K1 nutr m'),
(4	, 'FA00762PD1'	, 'Vit A, D, RRR-E y K premix'),
(5	, 'FA00380P01'	, 'Premix sulfato de cobre Kosher'),
(6	, '5070010RES'	, 'Citidin 5-monofosfato acido'),
(7	, '5070009RES'	, 'Adenosin 5-monofosfato acido'),
(8	, 'FA01056P01'	, 'Premix Vitam hidro y cobre 4'),
(9	, 'FA00776P01'	, 'WS Premix Vitaminas y Cobre 2'),
(10	, 'FA01040B05'	, 'Premix Vit A,D2,E,K1 Isomil In'),
(11	, 'FA00758P01'	, 'Premix Vit hidro ENG2 (16910)'),
(12	, 'FA00763P01'	, 'Premix de Vit 25913 FT117008EU'),
(13	, 'FA00923B05'	, 'OS Premix Vit China FT101775EU'),
(14	, 'FA00754B05'	, 'OS Premix de Vit 1 FT101494EU'),
(15	, 'FA01027P01'	, 'Prem de vit ES29435 FT101572EU'),
(16	, 'FA01035B05'	, 'Premix de vita OS 2 FT111223EU'),
(17	, '5070016RES'	, 'disodio Uridin 5-monofosfato'),
(18	, 'FA00333P01'	, 'Premix de vit WS 3 FT111233EU'),
(19	, 'FA00777A01'	, 'WS Premix total comfort'),
(20	, 'FA00168P01'	, 'Premix de vit HL10 FT101571EU'),
(21	, 'FA00749B05'	, 'Premix Vit/Min ENG2 FT091634EU'),
(22	, 'FA00766P01'	, 'Premix Vit/Min LF 46810'),
(23	, 'FA00765B05'	, 'Premix de vit EUOS FT117017EU'),
(24	, 'FA00367P01'	, 'WS Premix vitaminas y cobre 1'),
(25	, '5070014RES'	, 'disodio guanosin 5-monofosfato'),
(26	, 'FA00189P01'	, 'Vita Premix 22278 (FT112631EU)'),
(27	, 'FA01054B05'	, 'Premix Vitaminas liposoluble 4'),
(28	, 'FA02326P01'	, 'Premix Vitaminas hidrosolu 6'),
(29	, 'FA01842P01'	, 'Premix Vitaminas Hidrosolubl 7'),
(30	, 'FA00952B05'	, 'Premix Vitaminas Liposoluble 5'),
(31	, 'FA01841P01'	, 'Premix Vitaminas Hidrosolubl 9'),
(32	, 'FA00087B05'	, 'Premix vitaminas A,D3,E,K EEC'),
(33	, '5049006RES'	, 'Premix Hierro Sulfat FT127016B'),
(34	, 'FA04622B05'	, 'OS VITAMIN PREMIX 7')
~~~

- Wyświetl produkty rozpoczynające się na FA
~~~ sql
select distinct left(code, 7)  as code from finish_good where left(code, 7) like 'FA%'
~~~

- Wyświetl ilość produktów gotowych z grupy B05
~~~ sql
select count(*) from finish_good where RIGHT(code, 3) = 'B05'
~~~


- Znajdź produkty w których w nazwie występuje słowo 'Premix'
~~~ sql
select * from finish_good where name like '%Premix%'
~~~


- Ile produktów pakowanych jest w określony sposób?
~~~ sql
select 
	right(code, 3) as packing_group,
	count(*) as packing_count
from finish_good
group by right(code, 3)
~~~

- Ile jest poszczególnych produktów (na podst. 2 pierwszych znaków w kodzie)
~~~ sql
select 
	left(code, 2),
	count(*)
from finish_good
group by left(code, 2)
~~~



- ile jest aktywnych i nieaktywnych klientów w poszczególnych sklepach?

~~~ sql
select 
	address.address,
	customer.active,
	count(*) as customer_count
from customer
	inner join store
		on customer.store_id = store.store_id
	inner join address
		on store.address_id = address.address_id
group by address.address, customer.active
order by address.address, customer.active

~~~


## Case

~~~ sql
select 
	first_name, 
	last_name, 
	active,
	display_active = 
	case active
		when 1 then 'Aktywny'
		when 0 then 'Nieaktywny'
	end
from customer
~~~

- przetłumacz rating filmu na język polski
~~~ sql
select 
	title, 
	rating,
	rating_pl = 
	case rating 	
		when 'NC-17' then 'od 17 lat'
		when 'PG' then 'BO z rodzicami'
		when 'PG-13' then 'od 13 lat'
		when 'G' then 'BO'
		when 'R' then 'dla dorosłych'
	end 	
from film
~~~

- Ile jest filmów w poszczególnych kategoriach wiekowych (rating)?

~~~ sql
select 
	case rating 	
		when 'NC-17' then 'od 17 lat'
		when 'PG' then 'BO z rodzicami'
		when 'PG-13' then 'od 13 lat'
		when 'G' then 'BO'
		when 'R' then 'dla dorosłych'
	end,
	count(*) as film_count
from film
group by case rating 	
		when 'NC-17' then 'od 17 lat'
		when 'PG' then 'BO z rodzicami'
		when 'PG-13' then 'od 13 lat'
		when 'G' then 'BO'
		when 'R' then 'dla dorosłych'
	end
~~~

- Uproszczenie zapytania z zastosowaniem podzapytania

~~~ sql
select 
	rating_pl,
	count(*) as film_count
from (select 
	rating_pl = case rating 	
		when 'NC-17' then 'od 17 lat'
		when 'PG' then 'BO z rodzicami'
		when 'PG-13' then 'od 13 lat'
		when 'G' then 'BO'
		when 'R' then 'dla dorosłych'
	end,
	title
from film) as film_pl
group by rating_pl
~~~

- Uproszczenie zapytania z zastosowaniem wyrazenia CTE (Common Table Expression)

~~~ sql
with film_pl as (select 
	rating = case rating 	
		when 'NC-17' then 'od 17 lat'
		when 'PG' then 'BO z rodzicami'
		when 'PG-13' then 'od 13 lat'
		when 'G' then 'BO'
		when 'R' then 'dla dorosłych'
	end,
	title
from film)

select 
	rating,
	count(*) as film_count from film_pl
group by rating
~~~


## Grupowanie po datach


- jakie mieliśmy przychody w poszczególnych latach?

~~~ sql
select
	datepart(year, payment_date) as year,
	sum(amount) as total
from payment
group by datepart(year, payment_date)
~~~

- jakie mieliśmy przychody w poszczególnych latach i miesiącach?
~~~ sql
select
	datepart(year, payment_date) as year,
	datepart(month, payment_date) as month,
	sum(amount) as total
from payment
group by 
	datepart(year, payment_date),
	datepart(month, payment_date)
order by year, month
~~~

## Funkcje okienkowe

### Narastająco

~~~ sql
select 
	amount,
	sum(amount) over (order by payment_id) as running_total
from payment
~~~

### Partycjonowanie danych

- Dochody narastająco w podziale na miesiące
~~~ sql
select 
	amount,
	datepart(month, payment_date) as month,
	sum(amount) over (partition by datepart(month, payment_date) order by payment_id) as running_total
from payment
~~~

-- ile było wypożyczeń filmów narastająco w podziale na lata
~~~ sql
select
	year,
	sum(rental_count) over (order by year) as running_total
from 
(select 
 datepart(year, rental_date) as year,
 count(*) as rental_count
from rental	
group by datepart(year, rental_date)
) as query

~~~

- z zastosowaniem wyrazeń CTE

~~~ sql
with query as (select 
 datepart(year, rental_date) as year,
 count(*) as rental_count
from rental	
group by datepart(year, rental_date)
) 

select
	year,
	sum(rental_count) over (order by year) as running_total
from query
~~~

## Zadanie

- Czy film 'Academy Dinosaur' jest dostepny w sklepie Store 1? 

~~~ sql

~~~

- Które filmy mamy 2 kopie?

~~~ sql
select 
	film.title,
	count(*) as number_of_copies 
from film
	inner join inventory
		on film.film_id = inventory.film_id
group by film.title
having count(*) = 2
~~~

- W których kategoriach filmów mamy powyżej 50 tytułów?

~~~ sql
select 
	category.name,
	count(*) as film_count
from film
	inner join film_category 
		on film.film_id = film_category.film_id
	inner join category
		on film_category.category_id = category.category_id
group by category.name
having count(*)> 50
order by film_count
~~~

- pokaż 3 kraje z których najczęściej wypożyczane są filmy

~~~ sql
select top(3)
	country.country,
	count(rental.rental_id) as rental_count
from rental
	inner join customer
		on rental.customer_id = customer.customer_id
	inner join address 
		on customer.address_id = address.address_id
	inner join city
		on city.city_id = address.city_id
	inner join country
		on city.country_id = country.country_id
	group by country.country
order by rental_count desc
~~~


- znajdź wypożyczenia, które nie zostały opłacone
~~~ sql
select distinct
	customer.first_name,
	customer.last_name
from rental	
	left outer join payment
		on rental.rental_id = payment.rental_id
	inner join customer
		on rental.customer_id = customer.customer_id
where 
	payment.payment_id is null
~~~	




# Lista funkcji
https://docs.microsoft.com/en-us/sql/t-sql/functions

https://www.tutorialspoint.com/t_sql/t_sql_functions.htm


# Pobieranie danych do Excela za pomocą zapytania SQL
https://www.mssqltips.com/sqlservertip/4585/using-microsoft-query-in-excel-to-retreive-sql-server-data/
