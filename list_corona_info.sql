-- SCCSID @(#)  1.16 03/16/21 18:20:01
-- list_corona_info.sql
-- 2020/05/10 created
-- 2020/05/11-13 added multiple country, us, world reports
-- 2020/05/13 added trends
-- 2020/06/21 exclude from date report unless nonzero
-- 2020/07/07 rmv us_world by_date enhance summaries
-- 2021/03/17 fix output path
source use_pandemic_db.sql;
system rm  list_corona_info.txt;
tee list_corona_info.txt;
SELECT CURDATE(),current_time();
select 'list corona info';
select corona_info_loaded, count(*)
from corona_info
group by corona_info_loaded;

select 'Statistics by country:';
select
location, max(total_cases), max(total_deaths),
(max(total_deaths)/max(total_cases))*100 as '% deaths'
-- ,last(cvd_death_rate)
from corona_info
where location <> 'World'
group by location
;
select 'Countries by highest % deaths:';
select
location, (max(total_deaths)/max(total_cases))*100 as '% deaths',max(total_cases), max(total_deaths)
from corona_info
where location <> 'World'
group by location
having ((max(total_deaths)/max(total_cases))*100 > 0)
order by (max(total_deaths)/max(total_cases))*100 desc, location asc
;

select 'Country (top 10) with most cases';
select
location, max(total_cases), max(total_deaths),
(max(total_deaths)/max(total_cases))*100 as '% deaths'
from corona_info
where location <> 'World' and
   total_cases = (select max(total_cases) from corona_info where location <> 'World')
group by location
-- order by total_cases desc,location
-- limit 10
;
select 'Country with most cases/million';
select
location, max(total_cases), max(total_deaths),max(total_cases_per_million),
(max(total_deaths)/max(total_cases))*100 as '% deaths'
from corona_info
where location <> 'World' and
      total_cases_per_million = (select max(total_cases_per_million) from corona_info where location <> 'World')
group by location
;
select 'Country with most tests/thousand';
select
location, max(total_cases), max(total_deaths),max(total_tests_per_thousand),
(max(total_deaths)/max(total_cases))*100 as '% deaths'
from corona_info
where location <> 'World' and
      total_tests_per_thousand = (select max(total_tests_per_thousand) from corona_info where location <> 'World')
group by location
;
select 'Country with most deaths';
select
location, max(total_cases), max(total_deaths),
(max(total_deaths)/max(total_cases))*100 as '% deaths'
from corona_info
where location <> 'World' and
      total_deaths = (select max(total_deaths) from corona_info where location <> 'World')
group by location
;
select 'Country with most deaths/million';
select
location, max(total_cases), max(total_deaths),max(total_deaths_per_million),
(max(total_deaths)/max(total_cases))*100 as '% deaths'
from corona_info
where location <> 'World' and
      total_deaths_per_million = (select max(total_deaths_per_million) from corona_info where location <> 'World')
group by location
;
select 'Country with above average deaths/million' ;
select avg(total_deaths_per_million) from corona_info where location <> 'World' ;
select
location, max(total_cases), max(total_deaths),max(total_deaths_per_million),
(max(total_deaths)/max(total_cases))*100 as '% deaths'
from corona_info
where location <> 'World' and
      total_deaths_per_million > (select avg(total_deaths_per_million) from corona_info where location <> 'World')
group by location 
order by max(total_deaths_per_million) desc
;
-- select 'United States:';
--
-- select
-- date, max(total_cases), max(total_deaths), max(total_tests),
-- max(new_cases),(max(total_deaths)/max(total_cases))*100 as '% deaths'
-- from corona_info
-- where location = 'United States' and 
--   (total_cases > 0 or total_deaths > 0 or total_tests > 0)
-- group by date desc;

select 'United States summary:';
select
min(date),max(date), max(total_cases), max(total_deaths), max(total_tests),
(max(total_deaths)/max(total_cases))*100 as '% deaths',
(max(total_cases)/max(total_tests))*100 as '% cases' 
from corona_info
where location = 'United States';
select max(date) into @us_maxdate from corona_info where location = 'United States';
select
date, total_cases_per_million, total_deaths_per_million,total_tests_per_thousand
from corona_info
where location = 'United States' and date = @us_maxdate;

-- select 'World by date:';
-- select
-- date, max(total_cases), max(total_deaths), max(total_tests),
-- max(new_cases),(max(total_deaths)/max(total_cases))*100 as '% deaths'
-- from corona_info
-- where location = 'World' and 
--   (total_cases > 0 or total_deaths > 0 or total_tests > 0)
-- group by date desc;

select 'World summary:';
select
min(date),max(date), max(total_cases), max(total_deaths), max(total_tests),
(max(total_deaths)/max(total_cases))*100 as '% deaths', 
(max(total_cases)/max(total_tests))*100 as '% cases' 
from corona_info
where location = 'World';
select max(date) into @world_maxdate from corona_info where location = 'World';
select
date, total_cases_per_million, total_deaths_per_million,total_tests_per_thousand
from corona_info
where location = 'World' and date = @world_maxdate;

--
select 'US and world trend 35 days';

select location,date,new_cases,new_deaths,(total_deaths/total_cases*100) as '% death rate'
from corona_info
where (date = (curdate()-interval 7 day) or
      date = (curdate()-interval 14 day) or
      date = (curdate()-interval 21 day) or
      date = (curdate()-interval 28 day) or
      date = (curdate()-interval 35 day) or
      date = curdate()-interval 1 day) and
      (location = 'United States' or location = 'World')
order by location,date desc;

select 'US and world trend 14 days';

select cc.location,cc.date,cc.new_cases,cc.new_deaths,(cc.total_deaths/cc.total_cases*100) as '% death rate',
       (cc.new_cases - cp.new_cases) as 'net cases',
       (cc.new_deaths - cp.new_deaths) as 'net deaths'
from corona_info cc
     inner join 
     corona_info cp on cp.date = (cc.date - interval 1 day) and cc.location = cp.location
where (cc.date >= (curdate()-interval 14 day)) and
      (cc.location = 'United States' or cc.location = 'World')
order by cc.location,cc.date desc;

--
notee;
	
