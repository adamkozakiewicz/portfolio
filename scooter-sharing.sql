/* 
Scooter-share program offers flexible pricing: single-ride passes, full-day passes, and annual memberships. 
Casual riders (single-ride and full-day users) are less profitable than annual members. To drive growth, company aims 
to convert casual riders into members. Marketing efforts will focus on understanding the differences between these groups, 
identifying reasons for membership purchases, and leveraging digital media. I will analyze historical trip data to 
uncover trends and inform their strategy. 
I need to answer the question: How do annual members and casual riders use scooters differently?
*/


/* Data preparation: creating a new table with all rides from 2019. */

create table scooter-sharing44.trips.2019 as
    (
	select * from scooter-sharing44.trips.q1
    union all
    select * from scooter-sharing44.trips.q2
    union all
    select * from scooter-sharing44.trips.q3
    union all
    select * from scooter-sharing44.trips.q4
    );



/* Data preparation: creating a new column for the weekday of the ride's start */

alter table scooter-sharing44.trips.2019 add column day_of_week string;

update scooter-sharing44.trips.2019 
set day_of_week = format_date('%a', start_time) 
where true;


/* Analyzing the number of rides taken on different weekdays based on user type (subscriber or customer) */

select 
      count(day_of_week)      as trips_per_weekday
      ,day_of_week
      ,usertype
from scooter-sharing44.trips.2019
group by 
      day_of_week
      ,usertype
order by trips_per_weekday desc;


select 
      avg(tripduration)     as avg_tripduration
      ,usertype
      ,day_of_week
      ,gender

from scooter-sharing44.trips.2019
where gender is not null
group by 
      usertype
      ,day_of_week
      ,gender
order by usertype, gender



select 
      avg(tripduration)             as avg_tripduration
      ,round(avg(birthyear), 0)     as avg_birthyear
      ,usertype
      ,gender     

from scooter-sharing44.trips.2019
where gender is not null
group by 
      usertype
      ,gender
order by usertype, gender


	
with 
month as(
      select distinct
            extract(month from start_time)	as trip_month
      from scooter-sharing44.trips.2019
),
subscriber as(
      select 
            count(trip_id)			as trips
            ,extract(month from start_time) 	as trip_month
      from scooter-sharing44.trips.2019
      where usertype = 'Subscriber'
      group by trip_month
),
customer as(
      select 
            count(trip_id)         		as trips
            ,extract(month from start_time) 	as trip_month
      from scooter-sharing44.trips.2019
      where usertype = 'Customer'
      group by trip_month
)

select
      month.trip_month
      ,subscriber.trips
      ,customer.trips
from month
left join subscriber on subscriber.trip_month = month.trip_month
left join customer on customer.trip_month = month.trip_month
order by trip_month asc;




with 
hour as(
      select distinct
            extract(hour from start_time) as trip_hour
      from scooter-sharing44.trips.2019
),
subscriber as(
      select 
            count(trip_id)         as subscribers_trips
            ,extract(hour from start_time) as trip_hour
      from scooter-sharing44.trips.2019
      where usertype = 'Subscriber'
      group by trip_hour
),
customer as(
      select 
            count(trip_id)         as customers_trips
            ,extract(hour from start_time) as trip_hour
      from scooter-sharing44.trips.2019
      where usertype = 'Customer'
      group by trip_hour
)

select
      hour.trip_hour
      ,subscriber.subscribers_trips
      ,customer.customers_trips
from hour
left join subscriber on subscriber.trip_hour = hour.trip_hour
left join customer on customer.trip_hour = hour.trip_hour
order by trip_hour asc;



select 
      distinct percentile_cont(tripduration, 0.5) over()  as median
      ,usertype
from scooter-sharing44.trips.2019
where usertype = 'Customer';

select 
      distinct percentile_cont(tripduration, 0.5) over()  as median
      ,usertype
from scooter-sharing44.trips.2019
where usertype = 'Subscriber'

