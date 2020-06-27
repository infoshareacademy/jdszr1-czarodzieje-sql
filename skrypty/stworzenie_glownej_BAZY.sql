create table bazaFIN as (
	select 	cnt.countrycode, 
			cnt.shortname, 
			cnt.currencyunit, 
			cnt.alpha2code, 
			i.indicatorname, 
			i.indicatorcode, 
			i.value, 
			i."year" 
	from (
		select 
			countrycode, 
			shortname, 
			currencyunit,
			alpha2code 
		from country
		where currencyunit != '') as cnt
	join indicators as i on cnt.countrycode=i.countrycode
	where i."year" > 1989
	order by countrycode )