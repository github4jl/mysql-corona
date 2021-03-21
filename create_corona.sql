-- create_corona.sql
-- 2020/05/10 created
-- 2020/06/07 input added continent,new_tests_smoothed,
-- new_tests_smoothed_per_thousand, stringency_index
-- hospital_beds_per_100k now hospital_beds_per_thousand
-- 2020/10/08 new input file format

source use_pandemic_db.sql;
drop table corona_info;

CREATE TABLE corona_info (
iso_code character(3),	
continent character(20),
location character(20),	
date date,	
total_cases integer,	
new_cases integer,
new_cases_smoothed double precision,	
total_deaths integer,	
new_deaths	integer,
new_deaths_smoothed double precision,	
total_cases_per_million double precision,	
new_cases_per_million	double precision,
new_cases_smoothed_per_million	double precision,
total_deaths_per_million double precision,	
new_deaths_per_million	double precision,
new_tests	integer,
total_tests	integer,
total_tests_per_thousand double precision,	
new_tests_per_thousand	double precision,
new_tests_smoothed double precision,
new_tests_smoothed_per_thousand double precision,
tests_per_case double precision,
positive_rate double precision,
tests_units	integer,
stringency_index double precision,
population	integer,
population_density double precision,	
median_age	double precision,
aged_65_older double precision,	
aged_70_older double precision,	
gdp_per_capita	double precision,
extreme_poverty integer,	
cardiovasc_death_rate	double precision,
diabetes_prevalence double precision,	
female_smokers	double precision,
male_smokers	double precision,
handwashing_facilities	double precision,
hospital_beds_per_thousand double precision,
life_expectancy  double precision,
human_development_index double precision,
corona_info_loaded datetime
);
