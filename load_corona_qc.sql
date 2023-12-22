-- load_corona_qc.sql - quick qc check on load
-- 2020/10/08 written
-- 2021/03/05 add info on what's running

select 'running load_corona_qc';
source use_pandemic_db.sql;
select "corona_info";
select location,max(date),max(total_cases), max(total_deaths) 
from corona_info
where location = "United States";

select "corona_info_state";
select max(date)
from corona_info_state
into @statemaxdate;
select @statemaxdate,sum(positive),sum(death)
from corona_info_state
where date = @statemaxdate;

select "corona_info_ca";
select max(Most_Recent_Date)
from corona_info_ca
into @camaxdate;
select @camaxdate,sum(Total_Count_Confirmed),sum(Total_Count_Deaths)
from corona_info_ca
where Most_Recent_Date = @camaxdate;

