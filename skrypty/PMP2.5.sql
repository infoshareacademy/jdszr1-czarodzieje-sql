---4. Emisja PM - areozoli atmosferycznych (brak danych dla PM10) 
select distinct indicatorname from bazafin b 
where indicatorname ilike '%PM%' -- Brak danych o PM10, jedynie PM2.5

--wybieram wska�nik, kt�ry m�wi o populacji nara�onej na przekroczone wg WHO normy emisji tego py�u 
select * from bazafin
where indicatorname ilike '%PM%WHO%'

--tworzenie tabeli, kt�r� za pomoc� join po��czymy do reszty wska�nik�w a zawiera ona ranking wg lat wska�nika PM2.5 

create table PM25_2 as (
with PM25 as (select shortname, value, "Year" from bazafin
where indicatorname ilike '%PM%WHO%'and shortname in ('China', 'United States', 'India', 'Japan', 'Germany'))
select round(avg(value),2) as r_value, shortname, "Year"
from PM25
group by shortname, "Year"
order by "Year")

create table PM25_ranking as (select *, dense_rank () over (partition by "Year" order by r_value desc) as PM25_ranking from pm25_2)

-- pojawi� si� po po��czeniu nulle, kt�re wynikaj� z tego, �e dla wska�nika PM2.5 mamy tylko lata: 1990, 1995, 2000, 2005, 2010, 2011, 2013 
select distinct "Year" from pm25_ranking 
order by "Year"

select distinct "Year" from bazafin b 
order by "Year"

--do przemy�lenia 



