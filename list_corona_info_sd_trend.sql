-- SCCSID @(#)  1.5 07/01/20 09:05:21
-- list_corona_info_sd_trend.sql
-- 2020/09/12 written
-- 2020/09/23 do week over week for 28 day
-- 2020/10/04 add %, reduced labels
-- 2021/03/18 fix output path

source use_pandemic_db.sql;

-- create temp procedure
DROP PROCEDURE IF EXISTS list_corona_info_sd_temp_proc;
DELIMITER $$
CREATE PROCEDURE list_corona_info_sd_temp_proc()
-- Loop thru intervals
BEGIN

set @daysPrior=7; 
set @adjustmaxmostrecentdate=1;
set @daysPriorMax=28;
-- get most recent date based on data
select max(most_recent_date) from corona_info_ca into @max_most_recent_date;

WHILE (@daysPrior <= @daysPriorMax) DO

select 'AL to SD county trends',(@max_most_recent_date-interval @daysPrior day) as 'From',  (@max_most_recent_date - interval @adjustmaxmostrecentdate day) 'To',
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
where ccint.most_recent_date = (@max_most_recent_date-interval @daysPrior day) and
    ccint.county_name in ('Alameda','Stanislaus','Merced','Fresno','Kings','Kern','Los Angeles',
      'Orange','San Diego');

-- current day
select 
       (sum(cca.total_count_confirmed) - @ca_prior_total_count_confirmed) as 'New conf',
       (sum(cca.total_count_deaths) - @ca_prior_total_count_deaths) as 'New death',
       @ca_prior_total_count_confirmed as 'Prior conf',
       sum(cca.total_count_confirmed) as 'Latest conf',
       ((sum(cca.total_count_confirmed)/@ca_prior_total_count_confirmed)-1)*100 as '% Chg',
       @ca_prior_total_count_deaths as 'Prior death',
       sum(cca.total_count_deaths) as 'Latest death',
       ((sum(cca.total_count_deaths)/@ca_prior_total_count_deaths)-1)*100 as '% Chg'
from corona_info_ca cca
where cca.most_recent_date = (@max_most_recent_date - interval @adjustmaxmostrecentdate day) and
      cca.county_name in ('Alameda','Stanislaus','Merced','Fresno','Kings','Kern','Los Angeles',
      'Orange','San Diego');

-- county
select 
       cca.total_count_confirmed - ccint.total_count_confirmed as 'New conf',
       cca.total_count_deaths - ccint.total_count_deaths as 'Death',
       cca.county_name, 
       ccint.total_count_confirmed as 'Pr conf',
       cca.total_count_confirmed as 'Latest',
       (100* (cca.total_count_confirmed - ccint.total_count_confirmed) / ccint.total_count_confirmed)
         as '%',
       ccint.total_count_deaths as 'Pr death',
       cca.total_count_deaths as 'Latest',
       (100* (cca.total_count_deaths - ccint.total_count_deaths) / ccint.total_count_deaths)
         as '%'
from corona_info_ca cca
     inner join 
     corona_info_ca ccint 
     on ccint.most_recent_date = (@max_most_recent_date-interval @daysPrior day)  
     and cca.county_name = ccint.county_name
where cca.most_recent_date = (@max_most_recent_date - interval @adjustmaxmostrecentdate day) and
     cca.county_name in ('Alameda','Stanislaus','Merced','Fresno','Kings','Kern','Los Angeles',
      'Orange','San Diego')
-- order by cca.county_name;
order by cca.total_count_confirmed - ccint.total_count_confirmed desc,
         cca.total_count_deaths - ccint.total_count_deaths desc,
         cca.county_name;

set @daysPrior=@daysPrior + 7;
set @adjustmaxmostrecentdate=@adjustmaxmostrecentdate + 7;
END WHILE;
END;
-- End loop
$$
DELIMITER ;
-- run temp proc
system rm list_corona_info_sd_trend.txt;
tee list_corona_info_sd_trend.txt;

CALL list_corona_info_sd_temp_proc();

notee;
DROP PROCEDURE IF EXISTS list_corona_info_ca_temp_proc;
