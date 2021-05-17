-- SCCSID @(#)  1.2 06/26/20 20:25:56
-- load_corona_info_state.sql
-- 2020/07/30 created
-- 2020/10/08 input file changes
-- 2021/03/05 add info on what's loading
-- 2021/05/17 chg covidtracking_state.csv to corona_info_state.csv

select 'loading corona_info_state';
source use_pandemic_db.sql;
delete from corona_info_state;
LOAD DATA LOCAL INFILE '~/bin/mysql/corona_info_state.csv'
INTO TABLE corona_info_state
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(@date_YMD,
state	,
positive	,
probablecases ,
negative	,
pending	,
totalTestResults	,
hospitalizedCurrently	,
hospitalizedCumulative	,
inIcuCurrently	,
inIcuCumulative	,
onVentilatorCurrently	,
onVentilatorCumulative	,
recovered	,
dataQualityGrade	,
lastUpdateEt	,
dateModified	,
checkTimeEt	,
death	,
hospitalized	,
dateChecked	,
totalTestsViral	,
positiveTestsViral	,
negativeTestsViral	,
positiveCasesViral	,
deathConfirmed	,
deathProbable	,
totalTestEncountersViral,
totalTestsPeopleViral,
totalTestsAntibody,
positiveTestsAntibody,
negativeTestsAntibody,
totalTestsPeopleAntibody,
positiveTestsPeopleAntibody,
negativeTestsPeopleAntibody,
totalTestsPeopleAntigen,
positiveTestsPeopleAntigen,
totalTestsAntigen,
positiveTestsAntigen,
fips	,
positiveIncrease	,
negativeIncrease	,
total	,
totalTestResultsSource,

totalTestResultsIncrease	,
posNeg	,
deathIncrease	,
hospitalizedIncrease	,
hash	,
commercialScore	,
negativeRegularScore	,
negativeScore	,
positiveScore	,
score	,
grade
)
-- Most_Recent_Date is yyyymmdd
-- note: use right to just get year (yymmdd) so can use y not Y descriptor to prevent sccs expand
set date=str_to_date(right(@date_YMD,6),'%y%m%d');
update corona_info_state
set corona_info_state_loaded = now()
where corona_info_state_loaded is NULL;
select count(*) from corona_info_state;

