--wybÛr co piπtego roku dla przyk≥adowego wskaünika i srednia oraz odchylenie standardowe,
--a takze wspolczynnik (srednia do odchylenia standardowego), ktory daje bardzo ogolne pojecie o tempie wzrostu (im wiekszy, lepiej)
with lata as (
select shortname , "Year", round("value",2) as "value", 
round(lag("value") over (partition by shortname order by "Year"),2) from bazafin b
where indicatorname ilike 'GDP per capita, PPP (current international $)' --przyk≥πdowy wskaünik
and "Year" in (1990, 1995, 2000, 2005, 2010, 2013))
select shortname, round(avg("value"),2) as srednia, 
round(stddev("value"),2) as odchylenie, 
round(1/((avg("value")/stddev("value"))),2)
from lata
group by shortname 

--wybÛr otwierajπcego i zamykajπcego roku z wybranego przez nas przedzia≥u, a takze
--roczna predkosc wzrostu szukanej wartosci
select shortname , "Year", round("value",2) , 
lag("Year") over (partition by shortname order by "Year") , 
round(lag("value") over (partition by shortname order by "Year"),2), 
round((("value" - (lag("value") over (partition by shortname order by "Year")))/23),2) as sredni_reczny_przyrost
from bazafin b
where indicatorname ilike 'GDP per capita, PPP (current international $)' --przyk≥πdowy wskaünik
and "Year" in (1990, 2013)
