--PRZYGOTOWANIE TABEL Z DANYMI MAJ�CYMI NA CELU USTALENIE KORELACJI WZROSTU BOGACTWA I ROZWOJU

--Wyszukiwanie interesuj�cych nas wska�nik�w, na podstawie kt�rych sprawdzimy og�lnie rozw�j pa�stwa
select distinct i.indicatorname from indicators i 
where indicatorname ilike '%research%' or 
indicatorname ilike '%export%' or 
indicatorname ilike '%R%&%D%' 
--Technicians in R&D (per million people), 
--Researchers in R&D (per million people), 
--Research and development expenditure (% of GDP) - ,}te dwa wska�niki interesuj� nas najbardziej
--Exports of goods and services (BoP, current US$) - }

--Wyszukiawnie wska�nika PKB per capita pozwalaj�cego por�wna� kraje
select distinct indicatorname from indicators i
where indicatorname ilike '%GDP%per%capita%'
--GDP per capita, PPP (current international $)

--Stworzenie tabeli zawierj�cej jedynie wska�nik PKB per capita PPP dla kraj�w od 1989 roku
create table pkb_percapita as (
select * from bazafin b2 
where indicatorname ilike 'GDP per capita, PPP (current international $)')

--Stworzenie tabeli zawierj�cej ekwiwalent wolumenu eksportu dla kraj�w od 1989 roku
create table rozwoj_eksport as (
select * from bazafin b 
where indicatorname ilike 'Goods exports (BoP, current US$)'
order by shortname asc, "Year" asc)

--Stworzenie tabeli zawierj�cej jedynie wydatki na rozw�j i badania dla kraj�w od 1989 roku
create table rozwoj_RnD as (
select * from bazafin b 
where indicatorname ilike 'Research and development expenditure (% of GDP)'
order by shortname asc, "Year" asc)

--PORZ�DKOWANIE TABEL Z DANYMI

--PKB per capita: roczny wzrost
select shortname, indicatorname, "value", "Year", 
lag("value") over (partition by shortname order by "Year") as "lag", 
"value" - lag("value") over (partition by shortname order by "Year") as roznica,
row_number() over (partition by shortname order by "Year") as ile_wierszy from rozwoj_pkb_percapita rpp
where shortname ilike 'qatar';
------------------
create table ranking_pkbpc as (
with roznica as (
select shortname, indicatorname, "value", "Year", 
lag("value") over (partition by shortname order by "Year") as "lag", 
"value" - lag("value") over (partition by shortname order by "Year") as roznica,
row_number() over (partition by shortname order by "Year") as ile_wierszy from rozwoj_pkb_percapita rpp)

select shortname, 
round(max("lag"),2) as "max", --najwieksza wartosc PKB w zarejestrowanycm okresie
round(min("lag"),2) as "min", --najmniejsza wartosc PKB w zarejestrowanycm okresie
round(avg("value"),2) as "srednia", --srednia z tego okresu
round(stddev("value"),2) as odchylenie, --odchylenie standardowe z tego okresu majace pokazac odleglosc min i max od sredniej
round(((max("lag") - min("lag"))/(max(ile_wierszy)-1)),2) as szyb_wzr_bogactwa --szybkosc wzrostu bogactwa liczona jako amplituda podzielona przez ilosc lat
from roznica

group by shortname
having min("lag") is not null
order by avg("value") desc)
---------------------



