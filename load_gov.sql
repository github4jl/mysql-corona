-- load_gov.sql
-- 2020/10/10 created

source use_pandemic_db.sql;
delete from governors;
LOAD DATA LOCAL INFILE '~/bin/mysql/us_governors.csv'
INTO TABLE governors 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(state,
stateabbr,
governor,
party,
population,
popyear)
;
update governors
set governor_data_loaded = now();
select count(*) from governors;
