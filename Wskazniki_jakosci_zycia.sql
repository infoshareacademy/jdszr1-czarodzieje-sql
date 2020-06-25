

-- CZʌ� FINANSOWA, WYTYPOWANIE KRAJ�W DO ANALIZY JAKO�CI �YCIA - na podstawie analizy Dawida
-- najpierw tworzymy tabel� ograniczaj�c� dane dla lat >1989


select * 
  from pomocnicza p 
 where p.shortname in ('Macao SAR', 'China', 'Luxembourg', 'Singapore', 'Norway', 'Hong Kong SAR', 
                       'China', 'Equatorial Guinea', 'Ireland', 'Switzerland', 'United States',  
                       'Netherlands')
order by "Year" desc, 
          pkb desc


-- CZʌ� DOT. JAKO�CI �YCIA
--1. Life expectancy
-- przewidywana d�ugo�� �ycia - �rednia w poszczeg�lnych latach dla wszystkich pa�stw


with leb as 
	(select shortname, value, "Year" 
	   from bazafin
      where indicatorname ilike '%life expectancy at birth, total%')
select round(avg(value),2) przewidywana_dl_zycia, "Year" 
  from leb
group by "Year"
order by "Year"

-- najlepsi i najgorsi w ca�ym analizowanym zakresie (nie jest to miarodajne ze wzgl�du na skrajne warto�ci)

with leb as 
	(select shortname, value, "Year" 
	   from bazafin
      where indicatorname ilike '%life expectancy at birth, total%')
select round(avg(value),2) przewidywana_dl_zycia, shortname, "Year"
  from leb 
group by shortname, "Year"
order by round(max(value),2) asc
   limit 10

with leb as 
	(select shortname, value, "Year" 
	   from bazafin
      where indicatorname ilike '%life expectancy at birth, total%')
select round(avg(value),2) przewidywana_dl_zycia, shortname, "Year"
  from leb 
group by shortname, "Year"
order by round(max(value),2) desc
   limit 10


-- percentyle 
create table leb as 
	(select shortname, value as LEB, "Year" 
	   from bazafin
      where indicatorname ilike '%life expectancy at birth, total%')

with percentyle as
(
	select percentile_disc(0.25) within group (order by LEB) as p25, --61,27%
   	       percentile_disc(0.5) within group (order by LEB) as p50, --70,36%
           percentile_disc(0.75) within group (order by LEB) as p75 -- 75,043%
      from leb
)
select * 
  from percentyle p

select avg(LEB) as przewidywana_dl_zycia 
  from leb -- 67,70% - �rednia dla wszystkich pa�stw we wszystkich latach

-- a teraz nasze wybrane kraje rok po roku (korzystamy z poprzedniej tabeli pomocniczej z PKB i doklejamy do niej z tabel� z oze)

with pom1 as 
	(select * 
	   from leb 
      where shortname in ('Macao SAR', 'China', 'Luxembourg', 'Singapore', 'Norway', 'Hong Kong SAR', 
                          'China', 'Equatorial Guinea', 'Ireland', 'Switzerland', 'United States', 
                           'Netherlands') 
                        and "Year" < 2013
                   order by "Year" desc, 
                             LEB desc)
select * 
  from pom1 p1
join pomocnicza p 
  on p.shortname = p1.shortname
where p."Year"=p1."Year"

--2. Wydatki na edukacj� 

-- �rednia procent wydatk�w na edukacj� w odniesieniu do ca�o�ci wydatk�w rz�du
with edu as 
	(select shortname, value, "Year" 
	   from bazafin
      where indicatorname ilike '%Expenditure on education as % of total government expenditure (%)%')
select round(avg(value),2) as srednie_wydatki_edu, "Year" 
  from edu
group by "Year"
order by "Year"

-- najlepsi i najgorsi w ca�ym analizowanym zakresie  (nie jest to miarodajne ze wzgl�du na skrajne warto�ci)

with edu as 
	(select shortname, value, "Year" 
	   from bazafin
      where indicatorname ilike '%Expenditure on education as % of total government expenditure (%)%')
select round(avg(value),2), shortname, "Year"
 from edu
group by shortname, "Year"
order by round(max(value),2) asc
   limit 10

with edu as 
	(select shortname, value, "Year" 
	   from bazafin
      where indicatorname ilike '%Expenditure on education as % of total government expenditure (%)%')
select round(avg(value),2) as srednie_wydatki_edu, shortname, "Year"
 from edu
group by shortname, "Year"
order by round(max(value),2) desc
   limit 10
-- percentyle 
create table edu as 
	(select shortname, value as edu, "Year" 
		from bazafin
	   where indicatorname ilike '%Expenditure on education as % of total government expenditure (%)%')

with percentyle as
(
	select  percentile_disc(0.25) within group (order by edu) as p25, --11,16%
   		    percentile_disc(0.5) within group (order by edu ) as p50, --14,33%
            percentile_disc(0.75) within group (order by edu) as p75 -- 18,21%
	   from edu
)
select * 
   from percentyle p

select avg(edu) as srednie_wydatki_edukacja 
  from edu -- 15% - �rednia dla wszystkich pa�stw we wszystkich latach

-- a teraz nasze wybrane kraje rok po roku (korzystamy z poprzedniej tabeli pomocniczej z PKB i doklejamy do niej z tabel� z CO2)

with pom2 as 
	(select * 
	   from edu as e
      where shortname in ('Macao SAR', 'China', 'Luxembourg', 'Singapore', 'Norway', 'Hong Kong SAR', 
                          'China', 'Equatorial Guinea', 'Ireland', 'Switzerland', 'United States', 
                          'Netherlands') 
                      and "Year" < 2013 
                      and "Year" > 1997
                 order by "Year" desc, 
                           edu desc)
select * 
  from pom2 p2
join pomocnicza p 
  on p.shortname = p2.shortname
where p."Year"=p2."Year"

-- Po analizie stwierdzono, �e wska�nik wydatk�w na edukacj� nie mo�e by� to wska�nik �wiadcz�cy o jako�ci �ycia, poniewa� : dane s� niepe�ne, 
--a ponadto wysokie wydatki niekoniecznie przek�adaj� si� na jako�� �ycia, poniewa� wyst�puj� w krajach s�abo rozwini�tych, 
-- gdzie w og�le wydatki na inne sektory s� niskie, wi�c warto�� bezwgl�dna r�wnie�
