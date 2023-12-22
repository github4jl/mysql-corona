-- SCCSID @(#)  1.5 07/01/20 09:05:21
-- treemap_ca_trend.sql
-- 2020/12/07 written
-- 2021/03/14 use just filename for csv
source use_pandemic_db.sql;
system sudo rm /var/lib/mysql/pandemic/treemap_ca_trend.csv;
set @daysPrior=7;
-- get most recent date based on data
select max(most_recent_date) from corona_info_ca into @max_most_recent_date;

-- county
select 
       cca.county_name, 
       cca.total_count_confirmed - ccint.total_count_confirmed as 'New conf',
       ((cca.total_count_deaths - ccint.total_count_deaths) /
 	(cca.total_count_confirmed - ccint.total_count_confirmed)*100) as '% death'
--       ccint.total_count_confirmed as 'Prior conf',
--       cca.total_count_confirmed as 'latest conf',
--       ccint.total_count_deaths as 'Prior death',
--       cca.total_count_deaths as 'latest death'
-- into outfile '~/bin/mysql/treemap_ca_trend.csv'
into outfile 'treemap_ca_trend.csv'
--     terminated by ","
from corona_info_ca cca
     inner join 
     corona_info_ca ccint 
     on ccint.most_recent_date = (@max_most_recent_date-interval @daysPrior day)  
     and cca.county_name = ccint.county_name

where cca.most_recent_date = (@max_most_recent_date - interval 1 day)
;
select 'moving file from mysql to local' as '';
system sudo ls -l /var/lib/mysql/pandemic/treemap_ca_trend.csv;
system sudo mv /var/lib/mysql/pandemic/treemap_ca_trend.csv treemap_ca_trend.csv;
system sudo ls -l treemap_ca_trend.csv;
