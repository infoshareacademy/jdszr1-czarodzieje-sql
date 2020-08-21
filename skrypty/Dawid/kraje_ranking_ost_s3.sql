--SUMA PUNKTOW
create table ostateczny_ranking as (
select 
	dense_rank() over (order by rp.punkty + re.punkty + rz.punkty + rh.punkty + rt.punkty desc)	as miejsce,
	rp.shortname as kraj ,
	rp.ranga as PKB_miejsce,
	rp.punkty as punkty_PKB,
	re.ranga as edukacja_miejsce,
	re.punkty as punkty_edukacja,
	rz.ranga as bezrobocie_miejsce,
	rz.punkty as punkty_zatrudnienie,
	rh.ranga as zdrowie_miejsce,
	rh.punkty as punkty_zdrowie,
	rt.ranga as miejsce_turyzm,
	rt.punkty as punkty_turyzm,
	rp.punkty + re.punkty + rz.punkty + rh.punkty + rt.punkty as suma_punkty
from rozwoj_pkb rp 
join rozwoj_edu re on re.shortname = rp.shortname 
join rozwoj_bezr rz on rz.shortname = rp.shortname 
join rozwoj_zdr rh on rh.shortname = rp.shortname 
join rozwoj_tur rt on rt.shortname = rp.shortname
limit 30);
