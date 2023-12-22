-- list_state_gov.sql
-- 2020/10/10 created
-- 2020/10/12 add summary stats by party
-- 2020/10/19 add titles, combined %
-- 2021/03/14 use $HOME

source use_pandemic_db.sql;
system rm $HOME/bin/mysql/list_state_gov.txt;
tee $HOME/bin/mysql/list_state_gov.txt;

select current_date, current_time;

select "infection rate high to low" as "in order by";

select 
  state.state,
  gov.party,
  (sum(state.positive) + sum(state.negative)) as 'Tests',
  (sum(state.positive)/(sum(state.positive) + sum(state.negative))*100) as '% Pos',
  sum(state.deathIncrease) as 'Inc Death',
  ((sum(state.deathIncrease) / max(gov.population))*100) as '% Death',
  sum(state.hospitalizedIncrease) as 'Inc Hosp',
  max(gov.population) as 'Pop'
from corona_info_state as state
inner join governors as gov
on state.state = gov.stateabbr
group by state.state, gov.party
order by (sum(state.positive)/(sum(state.positive) + sum(state.negative))*100)  desc
;

select "death rate high to low" as "in order by";

select state.state,
  gov.party,
  (sum(state.positive) + sum(state.negative)) as 'Tests',
  (sum(state.positive)/(sum(state.positive) + sum(state.negative))*100) as '% Pos',
  sum(state.deathIncrease) as 'Inc Death',
  ((sum(state.deathIncrease) / max(gov.population))*100) as '% Death',
  sum(state.hospitalizedIncrease) as 'Inc Hosp',
  max(gov.population) as 'Pop'
from corona_info_state as state
inner join governors as gov
on state.state = gov.stateabbr
group by state.state, gov.party
order by ((sum(state.deathIncrease) / max(gov.population))*100) desc
;

-- compare parties
select sum(deathIncrease),
(sum(state.positive)/(sum(state.positive) + sum(state.negative))*100)
into @repdeath,@reppctpos
from corona_info_state as state
inner join governors as gov
on state.state = gov.stateabbr
where  gov.party = 'Republican';

select sum(deathIncrease),
(sum(state.positive)/(sum(state.positive) + sum(state.negative))*100)
into @demdeath,@dempctpos
from corona_info_state as state
inner join governors as gov
on state.state = gov.stateabbr
where gov.party = 'Democratic';

select sum(population)
into @reppop
from governors
where party = 'Republican';

select sum(population)
into @dempop
from governors
where  party = 'Democratic';

select "combined death+infection rate high to low" as "in order by";

select 
  state.state,
  gov.party,
  (sum(state.positive)/(sum(state.positive) + sum(state.negative))*100) as '% Pos',
  ((sum(state.deathIncrease) / max(gov.population))*100) as '% Death',
  (sum(state.positive)/(sum(state.positive) + sum(state.negative))*100) +
  ((sum(state.deathIncrease) / max(gov.population))*100) as '% combined'
from corona_info_state as state
inner join governors as gov
on state.state = gov.stateabbr
group by state.state, gov.party
order by (sum(state.positive)/(sum(state.positive) + sum(state.negative))*100) +
  ((sum(state.deathIncrease) / max(gov.population))*100) desc;

select "party summaries";

select 
  'Republican',@reppop as 'Pop',
  @reppctpos as '% pos',
  @repdeath as 'Deaths',
  format((@repdeath/@reppop*100),4) as '% death';
select 
  'Democratic',@dempop as 'Pop',
  @dempctpos as '% pos',
  @demdeath as 'Deaths',
  format((@demdeath/@dempop*100),4) as '% death';

notee;
