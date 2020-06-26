--RANKING KRAJOW W ODNIESIENIU DO WYBRANYCH WSKAZNIKOW
--(Ze wzgledu na dostepnosc danych, przedzial czasowy, to lata 1995-2013))

--BOGACTWO - Wszkanznik, na podstawie, ktorego bêd¹ analizowane pozostale wskazniki (predkosc wzrostu PKB per capita)
with pkb_alt as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value", 
 	lag("Year") over (partition by shortname order by "Year") as poprzedni_rok, 
 	round(lag("value") over (partition by shortname order by "Year"),2) as poprzednia_wartosc, 
 	round((("value" - (lag("value") over (partition by shortname order by "Year")))/(2013-1995)),2) as sredni_roczny_przyrost
from bazafin b
where indicatorname = 'GDP per capita, PPP (current international $)' --przyk³adowy wskaŸnik
	and "Year" in (1995, 2013))
select 
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
			and dense_rank() over (order by sredni_roczny_przyrost desc) < 20 
		then 5
	else 1
 end as punkty
from pkb_alt
where sredni_roczny_przyrost is not null
limit 50;

--EDUKACJA:
 --  Adjusted savings: education expenditure (current US$) <- 1990-2013

--ZATRUDNIENIE:
--  Unemployment, total (% of total labor force) <- 1991-2014

 --ZDROWIE:
 --  Health expenditure, public (% of government expenditure) <-1995-2013
 
--TURYZM (ilosc przybywajacych turystow swiadczy o atrakcyjnosci, bezpieczenstwie kraju, a takze posrednio o infrastrukturze)
-- International tourism, number of arrivals <- 1995-2013