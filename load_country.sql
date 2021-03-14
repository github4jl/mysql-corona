-- load_country.sql
-- 2020/04/03 created; load from
source use_geography_db.sql;
-- SET character_set_database=utf8;
LOAD DATA LOCAL INFILE '~/bin/mysql/countryInfo.txt' 
INTO TABLE  country_info
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 51 LINES
;
