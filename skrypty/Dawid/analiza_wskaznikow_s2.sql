--RANKING KRAJOW W ODNIESIENIU DO WYBRANYCH WSKAZNIKOW
--(Ze wzgledu na dostepnosc danych, przedzial czasowy, to lata 1995-2013))
--Kazdy kraj otrzymuje w kazdej kategorii punkty, ktore nastepnie zostane zsumowane celem stworzenia rankingu,
--ktory oceni ogolna szybkosc rozwoju jakosci zycia.

--BOGACTWO - Wskanznik, na podstawie, ktorego bêd¹ analizowane pozostale wskazniki (predkosc wzrostu PKB per capita)
create table pkb_alt as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value", 
 	lag("Year") over (partition by shortname order by "Year") as poprzedni_rok, 
 	round(lag("value") over (partition by shortname order by "Year"),2) as poprzednia_wartosc, 
 	round((("value" - (lag("value") over (partition by shortname order by "Year")))/(2013-1995)),2) as sredni_roczny_przyrost
from bazafin b
where indicatorname = 'GDP per capita, PPP (current international $)'
	and "Year" in (1995, 2013));

create table rozwoj_pkb as (select 
 	shortname , 
 	sredni_roczny_przyrost , 
 	dense_rank() over (order by sredni_roczny_przyrost desc) as ranga ,
 	case 
 		when dense_rank() over (order by sredni_roczny_przyrost desc) = 1 then 55 
		when dense_rank() over (order by sredni_roczny_przyrost desc) = 2 then 50
		when dense_rank() over (order by sredni_roczny_przyrost desc) = 3 then 45
		when dense_rank() over (order by sredni_roczny_przyrost desc) = 4 then 40
		when dense_rank() over (order by sredni_roczny_przyrost desc) = 5 then 35
		when dense_rank() over (order by sredni_roczny_przyrost desc) = 6 then 30
		when dense_rank() over (order by sredni_roczny_przyrost desc) = 7 then 25
		when dense_rank() over (order by sredni_roczny_przyrost desc) = 8 then 20
		when dense_rank() over (order by sredni_roczny_przyrost desc) = 9 then 15
		when dense_rank() over (order by sredni_roczny_przyrost desc) = 10 then 10
		when dense_rank() over (order by sredni_roczny_przyrost desc) > 10
			and dense_rank() over (order by sredni_roczny_przyrost desc) <= 20 
		then 5
		when dense_rank() over (order by sredni_roczny_przyrost desc) >= 21
			and dense_rank() over (order by sredni_roczny_przyrost desc) <= 30
		then 1
	else 0
 end as punkty
from pkb_alt
where sredni_roczny_przyrost is not null
limit 50);

--EDUKACJA:
create table edukacja_alt as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value", 
 	lag("Year") over (partition by shortname order by "Year") as poprzedni_rok, 
 	round(lag("value") over (partition by shortname order by "Year"),2) as poprzednia_wartosc, 
 	round((("value" - (lag("value") over (partition by shortname order by "Year")))/(2013-1995)),2) as sredni_roczny_przyrost
from bazafin b
where indicatorname = 'Adjusted savings: education expenditure (current US$)'
	and "Year" in (1995, 2013));

create table rozwoj_edu as (
select 
 	ea.shortname , 
 	ea.sredni_roczny_przyrost , 
 	dense_rank() over (order by ea.sredni_roczny_przyrost desc) as ranga ,
 	case 
 		when dense_rank() over (order by ea.sredni_roczny_przyrost desc) = 1 then 55 
		when dense_rank() over (order by ea.sredni_roczny_przyrost desc) = 2 then 50
		when dense_rank() over (order by ea.sredni_roczny_przyrost desc) = 3 then 45
		when dense_rank() over (order by ea.sredni_roczny_przyrost desc) = 4 then 40
		when dense_rank() over (order by ea.sredni_roczny_przyrost desc) = 5 then 35
		when dense_rank() over (order by ea.sredni_roczny_przyrost desc) = 6 then 30
		when dense_rank() over (order by ea.sredni_roczny_przyrost desc) = 7 then 25
		when dense_rank() over (order by ea.sredni_roczny_przyrost desc) = 8 then 20
		when dense_rank() over (order by ea.sredni_roczny_przyrost desc) = 9 then 15
		when dense_rank() over (order by ea.sredni_roczny_przyrost desc) = 10 then 10
		when dense_rank() over (order by ea.sredni_roczny_przyrost desc) > 10
			and dense_rank() over (order by ea.sredni_roczny_przyrost desc) <= 20 
		then 5
		when dense_rank() over (order by ea.sredni_roczny_przyrost desc) >= 21
			and dense_rank() over (order by ea.sredni_roczny_przyrost desc) <= 30
		then 1
	else 0
 end as punkty
from edukacja_alt ea
inner join rozwoj_pkb rpkb on rpkb.shortname = ea.shortname
where ea.sredni_roczny_przyrost is not null);

--ZATRUDNIENIE (BEZROBOCIE) ujemne wartosci oznaczaja spadajacy odsetek bezrobocia:
create table bezrobocie_alt as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value", 
 	lag("Year") over (partition by shortname order by "Year") as poprzedni_rok, 
 	round(lag("value") over (partition by shortname order by "Year"),2) as poprzednia_wartosc, 
 	round((("value" - (lag("value") over (partition by shortname order by "Year")))/(2013-1995)),2) as sredni_roczny_przyrost
from bazafin b
where indicatorname = 'Unemployment, total (% of total labor force)'
	and "Year" in (1995, 2013));

create table rozwoj_bezr as (
select 
 	za.shortname , 
 	za.sredni_roczny_przyrost , 
 	dense_rank() over (order by za.sredni_roczny_przyrost) as ranga ,
 	case 
 		when dense_rank() over (order by za.sredni_roczny_przyrost) = 1 then 55 
		when dense_rank() over (order by za.sredni_roczny_przyrost) = 2 then 50
		when dense_rank() over (order by za.sredni_roczny_przyrost) = 3 then 45
		when dense_rank() over (order by za.sredni_roczny_przyrost) = 4 then 40
		when dense_rank() over (order by za.sredni_roczny_przyrost) = 5 then 35
		when dense_rank() over (order by za.sredni_roczny_przyrost) = 6 then 30
		when dense_rank() over (order by za.sredni_roczny_przyrost) = 7 then 25
		when dense_rank() over (order by za.sredni_roczny_przyrost) = 8 then 20
		when dense_rank() over (order by za.sredni_roczny_przyrost) = 9 then 15
		when dense_rank() over (order by za.sredni_roczny_przyrost) = 10 then 10
		when dense_rank() over (order by za.sredni_roczny_przyrost desc) > 10
			and dense_rank() over (order by za.sredni_roczny_przyrost desc) <= 20 
		then 5
		when dense_rank() over (order by za.sredni_roczny_przyrost desc) >= 21
			and dense_rank() over (order by za.sredni_roczny_przyrost desc) <= 30
		then 1
	else 0
 end as punkty
from bezrobocie_alt za
inner join rozwoj_pkb rpkb on rpkb.shortname = za.shortname
where za.sredni_roczny_przyrost is not null);

 --ZDROWIE:
create table zdrowie_alt as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value", 
 	lag("Year") over (partition by shortname order by "Year") as poprzedni_rok, 
 	round(lag("value") over (partition by shortname order by "Year"),2) as poprzednia_wartosc, 
 	round((("value" - (lag("value") over (partition by shortname order by "Year")))/(2013-1995)),2) as sredni_roczny_przyrost
from bazafin b
where indicatorname = 'Health expenditure, public (% of government expenditure)'
	and "Year" in (1995, 2013));

create table rozwoj_zdr as (
select 
 	ha.shortname , 
 	ha.sredni_roczny_przyrost , 
 	dense_rank() over (order by ha.sredni_roczny_przyrost desc) as ranga ,
 	case 
 		when dense_rank() over (order by ha.sredni_roczny_przyrost desc) = 1 then 55 
		when dense_rank() over (order by ha.sredni_roczny_przyrost desc) = 2 then 50
		when dense_rank() over (order by ha.sredni_roczny_przyrost desc) = 3 then 45
		when dense_rank() over (order by ha.sredni_roczny_przyrost desc) = 4 then 40
		when dense_rank() over (order by ha.sredni_roczny_przyrost desc) = 5 then 35
		when dense_rank() over (order by ha.sredni_roczny_przyrost desc) = 6 then 30
		when dense_rank() over (order by ha.sredni_roczny_przyrost desc) = 7 then 25
		when dense_rank() over (order by ha.sredni_roczny_przyrost desc) = 8 then 20
		when dense_rank() over (order by ha.sredni_roczny_przyrost desc) = 9 then 15
		when dense_rank() over (order by ha.sredni_roczny_przyrost desc) = 10 then 10
		when dense_rank() over (order by ha.sredni_roczny_przyrost desc) > 10
			and dense_rank() over (order by ha.sredni_roczny_przyrost desc) <= 20 
		then 5
		when dense_rank() over (order by ha.sredni_roczny_przyrost desc) >= 21
			and dense_rank() over (order by ha.sredni_roczny_przyrost desc) <= 30
		then 1
	else 0
 end as punkty
from zdrowie_alt ha
inner join rozwoj_pkb rpkb on rpkb.shortname = ha.shortname
where ha.sredni_roczny_przyrost is not null);
 
--TURYZM (ilosc przybywajacych turystow swiadczy o atrakcyjnosci, bezpieczenstwie kraju, a takze posrednio o infrastrukturze)
-- International tourism, number of arrivals <- 1995-2013
create table turyzm_alt as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value", 
 	lag("Year") over (partition by shortname order by "Year") as poprzedni_rok, 
 	round(lag("value") over (partition by shortname order by "Year"),2) as poprzednia_wartosc, 
 	round((("value" - (lag("value") over (partition by shortname order by "Year")))/(2013-1995)),2) as sredni_roczny_przyrost
from bazafin b
where indicatorname = 'International tourism, number of arrivals'
	and "Year" in (1995, 2013));

create table rozwoj_tur as (
select 
 	ta.shortname , 
 	ta.sredni_roczny_przyrost , 
 	dense_rank() over (order by ta.sredni_roczny_przyrost desc) as ranga ,
 	case 
 		when dense_rank() over (order by ta.sredni_roczny_przyrost desc) = 1 then 55 
		when dense_rank() over (order by ta.sredni_roczny_przyrost desc) = 2 then 50
		when dense_rank() over (order by ta.sredni_roczny_przyrost desc) = 3 then 45
		when dense_rank() over (order by ta.sredni_roczny_przyrost desc) = 4 then 40
		when dense_rank() over (order by ta.sredni_roczny_przyrost desc) = 5 then 35
		when dense_rank() over (order by ta.sredni_roczny_przyrost desc) = 6 then 30
		when dense_rank() over (order by ta.sredni_roczny_przyrost desc) = 7 then 25
		when dense_rank() over (order by ta.sredni_roczny_przyrost desc) = 8 then 20
		when dense_rank() over (order by ta.sredni_roczny_przyrost desc) = 9 then 15
		when dense_rank() over (order by ta.sredni_roczny_przyrost desc) = 10 then 10
		when dense_rank() over (order by ta.sredni_roczny_przyrost desc) > 10
			and dense_rank() over (order by ta.sredni_roczny_przyrost desc) <= 20 
		then 5
		when dense_rank() over (order by ta.sredni_roczny_przyrost desc) >= 21
			and dense_rank() over (order by ta.sredni_roczny_przyrost desc) <= 30
		then 1
	else 0
 end as punkty
from turyzm_alt ta
inner join rozwoj_pkb rpkb on rpkb.shortname = ta.shortname
where ta.sredni_roczny_przyrost is not null);