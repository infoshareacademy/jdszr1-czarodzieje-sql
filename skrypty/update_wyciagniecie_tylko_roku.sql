--dodanie nowej kolumny
alter table footnotes add column year1 text
alter table seriesnotes add column year1 text
--zakutalizowanie dodanych kolumn dane dotyczące roku
update footnotes set "year1" = right ("year" , 4)
update seriesnotes set "year1" = right ("year", 4)