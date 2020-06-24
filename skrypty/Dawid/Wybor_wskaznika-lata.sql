select shortname , "Year", "value" , 
lag("Year") over (partition by shortname order by "Year") , 
lag("value") over (partition by shortname order by "Year") from bazafin b
where indicatorname ilike 'GDP per capita, PPP (current international $)' --przyk≥πdowy wskaünik
and "Year" in (1990, 1995, 2000, 2005, 2010, 2013)

select shortname , "Year", "value" , 
lag("Year") over (partition by shortname order by "Year") , 
lag("value") over (partition by shortname order by "Year") from bazafin b
where indicatorname ilike 'GDP per capita, PPP (current international $)' --przyk≥πdowy wskaünik
and "Year" in (1990, 2013)
