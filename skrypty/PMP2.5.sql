---4. Emisja PM - areozoli atmosferycznych (brak danych dla PM10) 
select distinct indicatorname from bazafin b 
where indicatorname ilike '%PM%' -- Brak danych o PM10, jedynie PM2.5

--wybieram wskaŸnik, który mówi o populacji nara¿onej na przekroczone wg WHO normy emisji tego py³u 
select * from bazafin
where indicatorname ilike '%PM%WHO%'

--tworzenie tabeli, któr¹ za pomoc¹ join po³¹czymy do reszty wskaŸników a zawiera ona ranking wg lat wskaŸnika PM2.5 

create table PM25_2 as (
with PM25 as (select shortname, value, "Year" from bazafin
where indicatorname ilike '%PM%WHO%'and shortname in ('China', 'United States', 'India', 'Japan', 'Germany'))
select round(avg(value),2) as r_value, shortname, "Year"
from PM25
group by shortname, "Year"
order by "Year")

create table PM25_ranking as (select *, dense_rank () over (partition by "Year" order by r_value desc) as PM25_ranking from pm25_2)

-- pojawi¹ siê po po³¹czeniu nulle, które wynikaj¹ z tego, ¿e dla wskaŸnika PM2.5 mamy tylko lata: 1990, 1995, 2000, 2005, 2010, 2011, 2013 
select distinct "Year" from pm25_ranking 
order by "Year"

select distinct "Year" from bazafin b 
order by "Year"

--do przemyœlenia 



