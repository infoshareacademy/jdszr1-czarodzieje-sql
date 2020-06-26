

-- CZÊŒÆ FINANSOWA, WYTYPOWANIE KRAJÓW DO ANALIZY ŒRODOWISKOWEJ
-- najpierw tworzymy tabelê ograniczaj¹c¹ dane dla lat >1989

create table PKB as 
(select  * from bazafin  
where indicatorname ilike 'GDP, PPP (current international $)' and "Year" > 1989 )

-- najwy¿sze PKB (œrednia wszystkich lat)

select shortname, avg(value) from pkb 
group by shortname 
order by avg(value) desc
limit 5


-- tutaj kraje z najwiêkszym wzrostem PKB na przestrzeni 10 lat w zadanym przedziale
with PKB_pom as (select shortname, avg(value) as srednia, lag(avg(value),10) over (order by shortname) as count_lagged from pkb 
group by shortname  
order by avg(value) desc
limit 5)
select *,abs(100*(srednia - count_lagged)/ (count_lagged )) as year_diff from pkb_pom
order by year_diff desc
limit 5

-- i nasze wybrane kraje rok po roku - kraj, rok i wartoœæ PKB
create table pomocnicza as 
(select shortname, avg(value) as PKB, "Year" from pkb p
group by shortname, "Year" 
order by "Year" asc, PKB asc, shortname 
)

select * from pomocnicza p
where p.shortname in ('China', 'United States', 'India', 'Japan', 'Germany')
order by "Year" desc, pkb desc


-- CZÊŒÆ ŒRODOWISKOWA
--1. OZE
-- udzia³ procentowy energii ze Ÿróde³ odnawialnych - œrednia w poszczególnych latach dla wszystkich pañstw

with renewable as (select shortname, value, "Year" from bazafin
where indicatorname ilike '%renewable energy consumption%')

select round(avg(value),2), "Year" from renewable
group by "Year"
order by "Year"

-- najlepsi i najgorsi w ca³ym analizowanym zakresie (nie jest to miarodajne ze wzglêdu na skrajne wartoœci)

with renewable as (select shortname, value, "Year" from bazafin
where indicatorname ilike '%renewable energy consumption%')
select round(avg(value),2), shortname, "Year", lag(avg(value)) over (order by shortname, "Year") as count_lagged 
from renewable 
group by shortname, "Year"
order by round(max(value),2) asc
limit 10

with renewable as (select shortname, value, "Year" from bazafin
where indicatorname ilike '%renewable energy consumption%')
select round(avg(value),2), shortname, "Year", lag(avg(value)) over (order by shortname, "Year") as count_lagged 
from renewable 
group by shortname, "Year"
order by round(max(value),2) desc
limit 10


-- percentyle 
create table renewable as (select shortname, value as OZE, "Year" from bazafin
where indicatorname ilike '%renewable energy consumption%')

with percentyle as
(
   select percentile_disc(0.25) within group (order by OZE) as p25, --6,06%
   		percentile_disc(0.5) within group (order by OZE) as p50, --24,59%
          percentile_disc(0.75) within group (order by OZE) as p75 -- 63,93%
   from renewable
)
select * from percentyle p

select avg(OZE) from renewable -- 35,44% - œrednia dla wszystkich pañstw we wszystkich latach

-- a teraz nasze wybrane kraje rok po roku (korzystamy z poprzedniej tabeli pomocniczej z PKB i doklejamy do niej z tabelê z oze)

with pom1 as (select * from renewable r 
where shortname in ('China', 'United States', 'India', 'Japan', 'Germany') and "Year" < 2013
order by "Year" desc, OZE desc)
select * from pom1 p1
join pomocnicza p on p.shortname = p1.shortname
where p."Year"=p1."Year"

--2. CO2

-- œrednia produkcja CO2 na osobê we wszystkich krajach 
with CO2 as (select shortname, value, "Year" from bazafin
where indicatorname ilike '%CO2%metric%')

select round(avg(value),2), "Year" from co2
group by "Year"
order by "Year"

-- najlepsi i najgorsi w ca³ym analizowanym zakresie  (nie jest to miarodajne ze wzglêdu na skrajne wartoœci)

with CO2 as (select shortname, value, "Year" from bazafin
where indicatorname ilike '%CO2%metric%')
select round(avg(value),2), shortname, "Year", lag(avg(value)) over (order by shortname, "Year") as count_lagged 
from CO2
group by shortname, "Year"
order by round(max(value),2) asc
limit 10

with CO2 as (select shortname, value, "Year" from bazafin
where indicatorname ilike '%CO2%metric%')
select round(avg(value),2), shortname, "Year", lag(avg(value)) over (order by shortname, "Year") as count_lagged 
from CO2
group by shortname, "Year"
order by round(max(value),2) desc
limit 10

-- percentyle 
create table CO2 as (select shortname, value as co2, "Year" from bazafin
where indicatorname ilike '%CO2%metric%')

with percentyle as
(
   select percentile_disc(0.25) within group (order by co2) as p25, --0,54
   		percentile_disc(0.5) within group (order by co2) as p50, --2,22
          percentile_disc(0.75) within group (order by co2) as p75 -- 6,74
   from CO2
)
select * from percentyle p

select avg(co2) from CO2 -- 4,73% - œrednia dla wszystkich pañstw we wszystkich latach

-- a teraz nasze wybrane kraje rok po roku (korzystamy z poprzedniej tabeli pomocniczej z PKB i doklejamy do niej z tabelê z CO2)

with pom2 as (select * from CO2 as c
where shortname in ('China', 'United States', 'India', 'Japan', 'Germany') and "Year" < 2013
order by "Year" desc, CO2 desc)
select * from pom2 p2
join pomocnicza p on p.shortname = p2.shortname
where p."Year"=p2."Year"


-- 3. Zu¿ycie paliw kopalnych

-- udzia³ procentowy energii z paliw kopalnych - œrednia w poszczególnych latach dla wszystkich pañstw

with fossil as (select shortname, value, "Year" from bazafin
where indicatorname ilike '%fossil%fuel%consumption%')
select round(avg(value),2), "Year" from fossil
group by "Year"
order by "Year"

-- najlepsi i najgorsi w ca³ym analizowanym zakresie (nie jest to miarodajne ze wzglêdu na skrajne wartoœci)

with fossil as (select shortname, value, "Year" from bazafin
where indicatorname ilike '%fossil%fuel%consumption%')
select round(avg(value),2), shortname, "Year", lag(avg(value)) over (order by shortname, "Year") as count_lagged 
from fossil 
group by shortname, "Year"
order by round(max(value),2) asc
limit 10

with fossil as (select shortname, value, "Year" from bazafin
where indicatorname ilike '%fossil%fuel%consumption%')
select round(avg(value),2), shortname, "Year", lag(avg(value)) over (order by shortname, "Year") as count_lagged 
from fossil 
group by shortname, "Year"
order by round(max(value),2) desc
limit 10


-- percentyle 
create table fossil as (select shortname, value as fossil, "Year" from bazafin
where indicatorname ilike '%fossil%fuel%consumption%')

with percentyle as
(
   select percentile_disc(0.25) within group (order by fossil) as p25, --42,65%
   		percentile_disc(0.5) within group (order by fossil) as p50, --75,03%
          percentile_disc(0.75) within group (order by fossil) as p75 -- 90,55%
   from fossil
)
select * from percentyle p

select avg(fossil) from fossil -- 65,01% - œrednia dla wszystkich pañstw we wszystkich latach

-- a teraz nasze wybrane kraje rok po roku (korzystamy z poprzedniej tabeli pomocniczej z PKB i doklejamy do niej z tabelê z fossil)

with pom3 as (select * from fossil f 
where shortname in ('China', 'United States', 'India', 'Japan', 'Germany') and "Year" < 2013
order by "Year" desc, fossil desc)
select * from pom3 p3
join pomocnicza p on p.shortname = p3.shortname
where p."Year"=p3."Year"

-- korelacja miêdzy PKB a % energii z paliw kopalnych

with pom3 as (select * from fossil f 
where shortname in ('China', 'United States', 'India', 'Japan', 'Germany') and "Year" < 2013
order by "Year" desc, fossil desc)
select round(corr(p.pkb , p3.fossil)::numeric,2) from pom3 p3
join pomocnicza p on p.shortname = p3.shortname
where p."Year"=p3."Year"



