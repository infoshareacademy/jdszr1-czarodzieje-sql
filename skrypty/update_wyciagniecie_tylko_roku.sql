--Wyciągniecie tylko lat z kolumn, gdzie rok ma postać "YR1990"
	-- dodanie kolumny
alter table footnotes add column year1 text
alter table seriesnotes add column year1 text
	-- zakutalizowanie o TYLKO rok
update footnotes set "year1" = right ("year" , 4)
update seriesnotes set "year1" = right ("year", 4)