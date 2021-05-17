-- SCCSID @(#)  1.4 05/17/21 09:45:34
-- load_corona_info_ca.sql
-- data from https://data.chhs.ca.gov/dataset/california-covid-19-hospital-data-and-case-statistics
-- 2020/05/15 created
-- 2020/06/26 input changed on ca site, was '~/bin/mysql/covid19data.csv', 
-- new loc https://data.ca.gov/dataset/590188d5-8545-4c93-a9a0-e230f0db7290/resource/926fd08f-cc91-4828-af38-bd45de97f8c3/download/statewide_cases.csv 
-- new columns (using @dummy for ones to skip)
-- county,totalcountconfirmed,totalcountdeaths,newcountconfirmed,newcountdeaths,date
-- 2021/03/05 add info on what's loading
-- 2021/051/7 chg csv to corona_info_ca.csv from statewide_cases.csv

select 'loading corona_info_ca';
source use_pandemic_db.sql;
delete from corona_info_ca;
LOAD DATA LOCAL INFILE '~/bin/mysql/corona_info_ca.csv'
INTO TABLE corona_info_ca
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(County_Name,
Total_Count_Confirmed,	
Total_Count_Deaths,
@dummy,
@dummy,
@Most_Recent_Date_YMD)
-- Most_Recent_Date is yyyy-mm-dd
set Most_Recent_Date=str_to_date(@Most_Recent_Date_YMD, '%Y-%m-%d')
;
update corona_info_ca
set corona_info_ca_loaded = now()
where corona_info_ca_loaded is NULL;
select count(*) from corona_info_ca;

