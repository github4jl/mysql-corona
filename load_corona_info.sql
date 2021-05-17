-- load_corona_info.sql
-- data from https://ourworldindata.org/coronavirus-source-data
-- 2020/05/10 created
-- 2020/07/01 set corona_info_loaded = now() regardless if null or not
-- 2020/10/08 new input file format
-- 2021/03/05 add info on what's loading
-- 2021/05/17 chg owid-covid-data.csv to corona_info.csv

select 'loading corona_info';
source use_pandemic_db.sql;
delete from corona_info;
LOAD DATA LOCAL INFILE '~/bin/mysql/corona_info.csv'
INTO TABLE corona_info 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(iso_code,	
continent,
location,	
date,	
total_cases,	
new_cases,
new_cases_smoothed,	
total_deaths,
new_deaths,
new_deaths_smoothed,
total_cases_per_million,
new_cases_per_million,
new_cases_smoothed_per_million,
total_deaths_per_million,	
new_deaths_per_million,
new_tests,
total_tests,
total_tests_per_thousand,	
new_tests_per_thousand,
new_tests_smoothed,
new_tests_smoothed_per_thousand,
tests_per_case,
positive_rate,
tests_units,
stringency_index,
population,
population_density,	
median_age,
aged_65_older,
aged_70_older,
gdp_per_capita,
extreme_poverty,
cardiovasc_death_rate,
diabetes_prevalence,	
female_smokers,
male_smokers,
handwashing_facilities,
hospital_beds_per_thousand,
life_expectancy,
human_development_index
)
;
update corona_info
set corona_info_loaded = now();
select count(*) from corona_info;

