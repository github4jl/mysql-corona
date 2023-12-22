-- list_corona_info_state_trend.sql
-- 2020/07/30 written, added loop
-- 2020/08/01 add ca stats for date interval
-- 2021/03/16 fix path for output
source use_pandemic_db.sql;

-- create temp procedure
DROP PROCEDURE IF EXISTS list_corona_info_state_temp_proc;
DELIMITER $$
CREATE PROCEDURE list_corona_info_state_temp_proc()
-- Loop thru intervals
BEGIN

set @daysPrior=7;
set @daysPriorMax=22;

-- get most recent date based on data
select max(date) from corona_info_state into @max_most_recent_date;

-- get ca stats
select date,state, 
  (sum(positive) + sum(negative)) as 'Tests',
  (sum(positive)/(sum(positive) + sum(negative))*100) as '% Positive',
  sum(deathIncrease) as 'Increase Death',
  sum(hospitalizedIncrease) as 'Increase Hosp'
from corona_info_state
where date <= @max_most_recent_date and
      date >= (@max_most_recent_date - interval @daysPriorMax day) and
      state = 'CA'
group by date
order by date desc;


WHILE (@daysPrior <= @daysPriorMax) DO

select 'State trends',(@max_most_recent_date-interval @daysPrior day) as 'From',  @max_most_recent_date 'To',
       @daysPrior;

select state, 
  (sum(positive) + sum(negative)) as 'Tests',
  (sum(positive)/(sum(positive) + sum(negative))*100) as '% Positive',
  sum(deathIncrease) as 'Increase Death',
  sum(hospitalizedIncrease) as 'Increase Hosp'
from corona_info_state
where date <= @max_most_recent_date and
      date >= (@max_most_recent_date - interval @daysPrior day)
group by state
order by (sum(positive)/(sum(positive) + sum(negative))*100)  desc, state;
-- increment
set @daysPrior=@daysPrior + 7;

END WHILE;
END;
-- End loop
$$
DELIMITER ;
-- run temp proc
system rm list_corona_info_state_trend.txt;
tee list_corona_info_state_trend.txt;

CALL list_corona_info_state_temp_proc();

notee;
DROP PROCEDURE IF EXISTS list_corona_info_state_temp_proc;
