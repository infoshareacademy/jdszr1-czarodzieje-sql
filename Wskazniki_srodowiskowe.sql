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

-- i nasze wybrane kraje rok po roku
create table pomocnicza as 
(select shortname, avg(value) as PKB, "Year" from pkb p
group by shortname, "Year" 
order by "Year" asc, PKB asc, shortname 
)

select * from pomocnicza p
where p.shortname in ('China', 'United States', 'India', 'Japan', 'Germany')
order by "Year" desc, pkb desc



-- udzia³ procentowy energii ze Ÿróde³ odnawialnych - œrednia w poszczególnych latach dla wszystkich pañstw

with renewable as (select shortname, value, "Year" from bazafin
where indicatorname ilike '%renewable energy consumption%')

select round(avg(value),2), "Year" from renewable
group by "Year"
order by "Year"

-- najlepsi i najgorsi w ca³ym analizowanym zakresie

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


-- mo¿e lepiej sprawdŸmy percentyle
create table renewable as (select shortname, value as OZE, "Year" from bazafin
where indicatorname ilike '%renewable energy consumption%'')

with percentyle as
(
   select percentile_disc(0.25) within group (order by OZE) as p25, --6,06%
   		percentile_disc(0.5) within group (order by OZE) as p50, --24,59%
          percentile_disc(0.75) within group (order by OZE) as p75 -- 63,93%
   from renewable
)
select * from percentyle p

select avg(OZE) from renewable -- 35,44% - œrednia dla wszystkich pañstw we wszystkich latach

-- a teraz nasze wybrane kraje rok po roku (korzystamy z poprzedniej tabeli pomocniczej z PKB i doklejamy do niej z oze)
-- mam w¹tpliwoœci co do optymalnoœci tego rozwi¹znia, wiêc jakby co, œmia³o poprawiajcie :)

with pom1 as (select * from renewable r 
where shortname in ('China', 'United States', 'India', 'Japan', 'Germany') and "Year" < 2013
order by "Year" desc, OZE desc)
select * from pom1 p1
join pomocnicza p on p.shortname = p1.shortname
where p."Year"=p1."Year"








