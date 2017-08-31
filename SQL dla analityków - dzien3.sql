use AdventureWorks2014

-- wyciêcie fragmentu tekstu
select 
	substring(AccountNumber, 1, 2) ,
	case 
		when AccountNumber is not null then 0
	end,
	*
from 
	Sales.Customer



-- podzapytania

select * from 
(
	select 
	substring(AccountNumber, 1, 2) as Prefix,
	case 
		when AccountNumber is not null then 0
	end as Account,
	PersonId,
	StoreId
from 
	Sales.Customer
)  as t

go


-- CTE (Common Table Expression)
with myquery as
(
select 
	substring(AccountNumber, 1, 2) as Prefix,
	case 
		when AccountNumber is not null then 0
	end as Account,
	PersonId,
	StoreId
from 
	Sales.Customer
)

select * from myquery












