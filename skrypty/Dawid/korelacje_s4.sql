--KORELACJA
--skrypt ma na celu sprawdzenia korelacji pomiedzy wczesniejszymi wskaznikami, a wzrostem PKB na osobe

--PKB per capita
with kraje_pkb as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value"
from bazafin b
where indicatorname = 'GDP per capita, PPP (current international $)'
	and "Year" >= 1995
	and "Year" <= 2013
order by shortname asc, "Year" asc),

--EDUKACJA

kraje_edu as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value"
from bazafin b
where indicatorname = 'Adjusted savings: education expenditure (current US$)'
	and "Year" >= 1995
	and "Year" <= 2013
order by shortname asc, "Year" asc),

korelacja_pkb_edu as (
select 
	kraje_pkb.shortname,
	corr(kraje_pkb."value", kraje_edu."value") as korelacja
from kraje_pkb
join kraje_edu on kraje_pkb.shortname = kraje_edu.shortname
group by kraje_pkb.shortname)

select 
	'Korelacja PKB-Edukacja' as Wskazniki,
	avg(korelacja) as srednia_korelacja
from korelacja_pkb_edu;

--BEZROBOCIE

with kraje_pkb as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value"
from bazafin b
where indicatorname = 'GDP per capita, PPP (current international $)'
	and "Year" >= 1995
	and "Year" <= 2013
order by shortname asc, "Year" asc),

kraje_bezr as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value"
from bazafin b
where indicatorname = 'Unemployment, total (% of total labor force)'
	and "Year" >= 1995
	and "Year" <= 2013
order by shortname asc, "Year" asc),

korelacja_pkb_bezr as (
select 
	kraje_pkb.shortname,
	corr(kraje_pkb."value", kraje_bezr."value") as korelacja
from kraje_pkb
join kraje_bezr on kraje_bezr.shortname = kraje_pkb.shortname
group by kraje_pkb.shortname)

select 
	'Korelacja PKB-Bezrobocie' as Wskazniki,
	avg(korelacja) as srednia_korelacja
from korelacja_pkb_bezr;

--ZDROWIE

with kraje_pkb as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value"
from bazafin b
where indicatorname = 'GDP per capita, PPP (current international $)'
	and "Year" >= 1995
	and "Year" <= 2013
order by shortname asc, "Year" asc),

kraje_zdr as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value"
from bazafin b
where indicatorname = 'Health expenditure, public (% of government expenditure)'
	and "Year" >= 1995
	and "Year" <= 2013
order by shortname asc, "Year" asc),

korelacja_pkb_zdr as (
select 
	kraje_pkb.shortname,
	corr(kraje_pkb."value", kraje_zdr."value") as korelacja
from kraje_pkb
join kraje_zdr on kraje_zdr.shortname = kraje_pkb.shortname
group by kraje_pkb.shortname)

select 
	'Korelacja PKB-Opieka medyczna' as Wskazniki,
	avg(korelacja) as srednia_korelacja
from korelacja_pkb_zdr;

--TURYZM

with kraje_pkb as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value"
from bazafin b
where indicatorname = 'GDP per capita, PPP (current international $)'
	and "Year" >= 1995
	and "Year" <= 2013
order by shortname asc, "Year" asc),

kraje_tur as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value"
from bazafin b
where indicatorname = 'International tourism, number of arrivals'
	and "Year" >= 1995
	and "Year" <= 2013
order by shortname asc, "Year" asc),

korelacja_pkb_tur as (
select 
	kraje_pkb.shortname,
	corr(kraje_pkb."value", kraje_tur."value") as korelacja
from kraje_pkb
join kraje_tur on kraje_tur.shortname = kraje_pkb.shortname
group by kraje_pkb.shortname)

select 
	'Korelacja PKB-Turyzm' as Wskazniki,
	avg(korelacja) as srednia_korelacja
from korelacja_pkb_tur;
	