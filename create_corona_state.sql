-- create_corona_state.sql
-- 2020/07/28 created
-- 2020/10/04 add new fields (see diff)
-- 2020/10/08 input file changes

source use_pandemic_db.sql;
drop table corona_info_state;

CREATE TABLE corona_info_state (
date	date,
state	char(2),
positive	integer,
negative	integer,
probablecases integer,
pending	integer,
totalTestResults	integer,
hospitalizedCurrently	integer,
hospitalizedCumulative	integer,
inIcuCurrently	integer,
inIcuCumulative	integer,
onVentilatorCurrently	integer,
onVentilatorCumulative	integer,
recovered	integer,
dataQualityGrade	char(2),
lastUpdateEt	char(16),
dateModified	char(20),
checkTimeEt	char(11),
death	integer,
hospitalized	integer,
dateChecked	char(16),
totalTestsViral	integer,
positiveTestsViral	integer,
negativeTestsViral	integer,
positiveCasesViral	integer,
deathConfirmed	integer,
deathProbable	integer,
totalTestEncountersViral integer,
totalTestsPeopleViral	integer,
totalTestsAntibody	integer,
positiveTestsAntibody	integer,
negativeTestsAntibody	integer,
totalTestsPeopleAntibody	integer,
positiveTestsPeopleAntibody	integer,
negativeTestsPeopleAntibody	integer,
totalTestsPeopleAntigen	integer,
positiveTestsPeopleAntigen	integer,
totalTestsAntigen	integer,
positiveTestsAntigen	integer,
fips	integer,
positiveIncrease	integer,
negativeIncrease	integer,
total	integer,
totalTestResultsSource char(25),
totalTestResultsIncrease	integer,
posNeg	integer,
deathIncrease	integer,
hospitalizedIncrease	integer,
hash	char(40),
commercialScore	integer,
negativeRegularScore	integer,
negativeScore	integer,
positiveScore	integer,
score	integer,
grade	integer,
corona_info_state_loaded datetime
);


