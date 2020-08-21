---4. Emisja PM - areozoli atmosferycznych (brak danych dla PM10) 
select distinct indicatorname from bazafin b 
where indicatorname ilike '%PM%' -- Brak danych o PM10, jedynie PM2.5

--wybieram wska�nik, kt�ry m�wi o populacji nara�onej na przekroczone wg WHO normy emisji tego py�u 
select * from bazafin
where indicatorname ilike '%PM%WHO%'

--tworzenie tabeli, kt�r� za pomoc� join po��czymy do reszty wska�nik�w a zawiera ona ranking wg lat wska�nika PM2.5 

create table PM25_2 as (
with PM25 as (select shortname, value, "Year" from bazafin
where indicatorname ilike '%PM%WHO%')
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

-- ukazana zmiana jako procent zmiany jaka zasz�a w ci�du 13 lat 
select * from pm25_ranking pr 
where shortname in ('China', 'United States', 'India', 'Japan', 'Germany') and ("Year" = 1990 or "Year" = 2013) 
order by shortname, "Year" 

--sprawdzenie czy w ka�dym roku wyst�puje tyle samo pa�stw
select count (distinct shortname) as count_1990 from pm25_ranking pr where "Year" = 1990 
union 
select count (distinct shortname) as count_2013 from pm25_ranking pr where "Year" = 1995
union 
select count (distinct shortname) as count_2013 from pm25_ranking pr where "Year" = 2000
union 
select count (distinct shortname) as count_1990 from pm25_ranking pr where "Year" = 2005
union 
select count (distinct shortname) as count_1990 from pm25_ranking pr where "Year" = 2010
union 
select count (distinct shortname) as count_1990 from pm25_ranking pr where "Year" = 2013

-- powiedzmy �e jest ich 185


--sprawdzanie jaka jest jakaby�a najwi�ksza warto�� kiedykolwiek 
select max(r_value) from pm25_ranking pr 
-- ta warto�� to 100


-- sprawdzenie jak zasz�a zmiana od roku 1990 - 2013, ile procent spad�a czy da si� pro�ciej ni� ka�dy z kraj�w osobno?? 


select shortname, "Year", r_value, (r_value) * 100 / (select max (r_value) from pm25_ranking pr2) as per_cent, ( lag - ((r_value) * 100 / (select max (r_value) from pm25_ranking pr2)) ) as margin 
from (
select shortname, "Year", r_value, (lag(r_value) over (order by "Year")) as lag from (select * from pm25_ranking pr 
where shortname ilike 'United States' and ("Year" = 1990 or "Year" = 2013)
order by shortname, "Year") as new_P25) 
as new_2_P25  -- w tym przypadku mo�na u�y� po prostu r_value czy (lag - r_value) poniewa� max z r_value to po prostu 100, ale tu ju� standaryzacja do ka�dego ze wska�nik�w 

-- tu dodatkowo widzimy �redni� warto�� (nie procenty) 
select shortname, "Year", (select round(avg (r_value),2) from pm25_ranking pr2), r_value, (r_value) * 100 / (select max (r_value) from pm25_ranking pr2), 
( lag - ((r_value) * 100 / (select max (r_value) from pm25_ranking pr2)) ) as margin 
from (
select shortname, "Year", r_value, (lag(r_value) over (order by "Year")) as lag from (select * from pm25_ranking pr 
where shortname ilike 'United States' and ("Year" = 1990 or "Year" = 2013)
order by shortname, "Year") as new_P25) 
as new_2_P25

