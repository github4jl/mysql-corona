-- create_corona_ca.sql
-- 2020/05/15 created
source use_pandemic_db.sql;
drop table corona_info_ca;

CREATE TABLE corona_info_ca (
County_Name	character(20),
Most_Recent_Date	date,
Total_Count_Confirmed	integer,	
Total_Count_Deaths	integer,
COVID19_Positive_Patients	integer,
Suspected_COVID19_Positive_Patients	integer,
ICU_COVID19_Positive_Patients	integer,
ICU_COVID19_Suspected_Patients	integer,
corona_info_ca_loaded	datetime
);

describe corona_info_ca;

