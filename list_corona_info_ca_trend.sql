-- SCCSID @(#)  1.5 07/01/20 09:05:21
-- list_corona_info_ca_trend.sql
-- 2020/06/18 written, added loop
-- 2020/06/26 chg output from ...trends to ...trend
-- 2020/06/28 add CA totals
-- 2020/07/01 check for & use most current date in db, not assume curdate()
-- 2021/03/16 fix output path
source use_pandemic_db.sql;

-- craete temp procedure
DROP PROCEDURE IF EXISTS list_corona_info_ca_temp_proc;
DELIMITER $$
CREATE PROCEDURE list_corona_info_ca_temp_proc()
-- Loop thru intervals
BEGIN

set @daysPrior=7;
set @daysPriorMax=22;
-- get most recent date based on data
select max(most_recent_date) from corona_info_ca into @max_most_recent_date;

WHILE (@daysPrior <= @daysPriorMax) DO

select 'CA and CA county trends',(@max_most_recent_date-interval @daysPrior day) as 'From',  @max_most_recent_date 'To',
       @daysPrior;
-- CA sums - note cast to force to integer not decimal
-- prior date
select   
      cast(sum(ccint.total_count_confirmed) as unsigned),
      cast(sum(ccint.total_count_deaths) as unsigned)
into
    @ca_prior_total_count_confirmed,
    @ca_prior_total_count_deaths
from     corona_info_ca ccint 
where ccint.most_recent_date = (@max_most_recent_date-interval @daysPrior day);
-- current day
select 
       (sum(cca.total_count_confirmed) - @ca_prior_total_count_confirmed) as 'Net conf',
       (sum(cca.total_count_deaths) - @ca_prior_total_count_deaths) as 'Net death',
       @ca_prior_total_count_confirmed as 'Prior conf',
       sum(cca.total_count_confirmed) as 'latest conf',
       ((sum(cca.total_count_confirmed)/@ca_prior_total_count_confirmed)-1)*100 as '% Chg',
       @ca_prior_total_count_deaths as 'Prior death',
       sum(cca.total_count_deaths) as 'latest death',
       ((sum(cca.total_count_deaths)/@ca_prior_total_count_deaths)-1)*100 as '% Chg'
from corona_info_ca cca
where cca.most_recent_date = (@max_most_recent_date - interval 1 day)
;

-- county
select 
       cca.total_count_confirmed - ccint.total_count_confirmed as 'Net conf',
       cca.total_count_deaths - ccint.total_count_deaths as 'Net death',
       cca.county_name, 
       ccint.total_count_confirmed as 'Prior conf',
       cca.total_count_confirmed as 'latest conf',
       ccint.total_count_deaths as 'Prior death',
       cca.total_count_deaths as 'latest death'
from corona_info_ca cca
     inner join 
     corona_info_ca ccint 
     on ccint.most_recent_date = (@max_most_recent_date-interval @daysPrior day)  
     and cca.county_name = ccint.county_name
where cca.most_recent_date = (@max_most_recent_date - interval 1 day)
-- order by cca.county_name;
order by cca.total_count_confirmed - ccint.total_count_confirmed desc,
         cca.total_count_deaths - ccint.total_count_deaths desc,
         cca.county_name;

set @daysPrior=@daysPrior + 7;

END WHILE;
END;
-- End loop
$$
DELIMITER ;
-- run temp proc
system rm list_corona_info_ca_trend.txt;
tee list_corona_info_ca_trend.txt;

CALL list_corona_info_ca_temp_proc();

notee;
DROP PROCEDURE IF EXISTS list_corona_info_ca_temp_proc;
