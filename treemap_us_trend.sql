-- SCCSID @(#)  1.5 07/01/20 09:05:21
-- treemap_us_trend.sql
-- 2020/12/07 written
-- 2021/03/14 use just csv filename
source use_pandemic_db.sql;
system sudo rm /var/lib/mysql/pandemic/treemap_us_trend.csv;
set @daysPrior=7;
-- get most recent date based on data
select max(date) from corona_info_state into @max_most_recent_date;

-- us states
select 
       cca.state, 
       cca.positive - ccint.positive as 'New conf',
       ((cca.death - ccint.death) /
 	(cca.positive - ccint.positive)*100) as '% death'
into outfile 'treemap_us_trend.csv'
from corona_info_state cca
     inner join 
     corona_info_state ccint 
     on ccint.date = (@max_most_recent_date-interval @daysPrior day)  
     and cca.state = ccint.state

where cca.date = (@max_most_recent_date - interval 1 day)
;
select 'moving file from mysql to local' as '';
system sudo ls -l /var/lib/mysql/pandemic/treemap_us_trend.csv;
system sudo mv /var/lib/mysql/pandemic/treemap_us_trend.csv treemap_us_trend.csv;
system sudo ls -l treemap_us_trend.csv;
