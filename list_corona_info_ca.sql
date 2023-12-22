-- list_corona_info_ca.sql
-- 2020/05/15 written
-- 2021/03/16 fix ~
source use_pandemic_db.sql;
system rm list_corona_info_ca.txt;
tee list_corona_info_ca.txt;
select max(most_recent_date) as 'Latest date in database' from corona_info_ca;

select 'Alameda';
select county_name,most_recent_date,total_count_confirmed,total_count_deaths,
       (total_count_deaths/total_count_confirmed)*100 as '% deaths'
from corona_info_ca
where county_name = 'Alameda'
order by county_name,most_recent_date desc;

select 'CA totals';
select sum(total_count_confirmed),sum(total_count_deaths),
       (sum(total_count_deaths)/sum(total_count_confirmed))*100 as '% deaths'
from corona_info_ca
where most_recent_date = (select max(most_recent_date) from corona_info_ca);

select 'CA county totals';
select county_name,max(total_count_confirmed),max(total_count_deaths),
       (max(total_count_deaths)/max(total_count_confirmed))*100 as '% deaths'
from corona_info_ca
group by county_name
order by county_name;

select 'CA county %';
select sum(total_count_confirmed),
           sum(total_count_deaths)
into @sum_ca_confirmed,@sum_ca_deaths           
from corona_info_ca
where most_recent_date = (select max(most_recent_date) from corona_info_ca)
;

select county_name,max(total_count_confirmed),
       (max(total_count_confirmed)/@sum_ca_confirmed)*100 as '% CA confirmed',
       max(total_count_deaths),
       (max(total_count_deaths)/@sum_ca_deaths)*100 as '% CA deaths'
from corona_info_ca
group by county_name
order by county_name;


select 'CA county totals by total cases';
select county_name,max(total_count_confirmed),max(total_count_deaths),
       (max(total_count_deaths)/max(total_count_confirmed))*100 as '% deaths'
from corona_info_ca
group by county_name
order by max(total_count_confirmed) desc, county_name;

select 'CA county totals by deaths';
select county_name,max(total_count_confirmed),max(total_count_deaths),
       (max(total_count_deaths)/max(total_count_confirmed))*100 as '% deaths'
from corona_info_ca
group by county_name
order by max(total_count_deaths) desc, county_name;

notee;
