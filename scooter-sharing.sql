/* 
Scooter-share program in Chicago offers flexible pricing: single-ride passes, full-day passes, and annual memberships. 
Casual riders (single-ride and full-day users) are less profitable than annual members. To drive growth, company aims 
to convert casual riders into members. Marketing efforts will focus on understanding the differences between these groups, 
identifying reasons for membership purchases, and leveraging digital media. I will analyze historical trip data to 
uncover trends and inform their strategy. 
I need to answer the question: How do annual members and casual riders use scooters differently?
*/


/* Data preparation: creating a new table with all rides from 2019. */
create table scooter-sharing44.trips.2019 as(
	select * from scooter-sharing44.trips.q1
	union all
	select * from scooter-sharing44.trips.q2
	union all
	select * from scooter-sharing44.trips.q3
	union all
	select * from scooter-sharing44.trips.q4
);


/* Data preparation: creating a new column for the weekday of the ride's start. */
alter table scooter-sharing44.trips.2019 add column day_of_week string;

update scooter-sharing44.trips.2019 
set day_of_week = format_date('%a', start_time) 
where true;


/* Data exploration: checking the number of null values in each column */
select
      countif(trip_id is null) as null_trip_id
      ,countif(start_time is null) as null_start_time
      ,countif(end_time is null) as null_end_time
      ,countif(bikeid is null) as null_bikeid
      ,countif(tripduration is null) as null_tripduration
      ,countif(from_station_id is null) as null_from_station_id
      ,countif(from_station_name is null) as null_from_station_name
      ,countif(to_station_id is null) as null_to_station_id
      ,countif(to_station_name is null) as null_to_station_name
      ,countif(usertype is null) as null_usertype
      ,countif(gender is null) as null_gender
      ,countif(birthyear is null) as null_birthyear
      ,countif(day_of_week is null) as null_day_of_week
from scooter-sharing44.trips.2019;


/* Data exploration: checking length of trip id. */
select length('trip_id') 		as trip_length
from scooter-sharing44.trips.2019
group by trip_length


/* Analyzing the number of rides taken on different weekdays based on user type (subscriber or customer) and gender. */
select 
      count(day_of_week)      as trips_per_weekday
      ,day_of_week
      ,usertype
      ,gender
from scooter-sharing44.trips.2019
where gender is not null
group by 
      day_of_week
      ,usertype
      ,gender
order by trips_per_weekday desc;


/* Analyzing the average trip duration on diffrent weekdays based on user type and gender. */
select 
      avg(tripduration)/60	as avg_tripduration      /* in minutes */
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


/* Analyzing the average trip duration and the average user year of birth based on user type and gender. */
select 
      avg(tripduration)/60          as avg_tripduration      /* in minutes */
      ,round(avg(birthyear), 0)     as avg_birthyear
      ,usertype
      ,gender     
from scooter-sharing44.trips.2019
where gender is not null
group by 
      usertype
      ,gender
order by usertype, gender


/* Analyzing the number of rides per month based on user type. */	
with 
month as(
      select distinct
            extract(month from start_time)	as trip_month
      from scooter-sharing44.trips.2019),
subscriber as(
      select 
            count(trip_id)			as trips
            ,extract(month from start_time) 	as trip_month
      from scooter-sharing44.trips.2019
      where usertype = 'Subscriber'
      group by trip_month),
customer as(
      select 
            count(trip_id)         		as trips
            ,extract(month from start_time) 	as trip_month
      from scooter-sharing44.trips.2019
      where usertype = 'Customer'
      group by trip_month)
select
      month.trip_month
      ,subscriber.trips
      ,customer.trips
from month
left join subscriber on subscriber.trip_month = month.trip_month
left join customer on customer.trip_month = month.trip_month
order by trip_month asc;


/* Analyzing the number of rides per hour based on user type. */
with 
hour as(
      select distinct
            extract(hour from start_time) as trip_hour
      from scooter-sharing44.trips.2019),
subscriber as(
      select 
            count(trip_id)         		as subscribers_trips
            ,extract(hour from start_time) 	as trip_hour
      from scooter-sharing44.trips.2019
      where usertype = 'Subscriber'
      group by trip_hour),
customer as(
      select 
            count(trip_id)         		as customers_trips
            ,extract(hour from start_time) 	as trip_hour
      from scooter-sharing44.trips.2019
      where usertype = 'Customer'
      group by trip_hour)
select
      hour.trip_hour
      ,subscriber.subscribers_trips
      ,customer.customers_trips
from hour
left join subscriber on subscriber.trip_hour = hour.trip_hour
left join customer on customer.trip_hour = hour.trip_hour
order by trip_hour asc;


/* Analyzing the median trip duration based on user type */
select 
      distinct percentile_cont(tripduration, 0.5) over()  as median
      ,usertype
from scooter-sharing44.trips.2019
where usertype = 'Customer';

select 
      distinct percentile_cont(tripduration, 0.5) over()  as median
      ,usertype
from scooter-sharing44.trips.2019
where usertype = 'Subscriber';


/* Analyzing top 10 start stations nased on usertype */
select *
from(
      select
            from_station_name
            ,count(from_station_name)                 as from_total
            ,countif(usertype = 'Customer')         as from_customer
            ,rank() over(order by countif(usertype = 'Customer') desc)  as ranking
      from scooter-sharing44.trips.2019
      group by from_station_name
      order by from_customer desc)
where ranking <= 10; 	/* or limit 10, I knooow */


select *
from(
      select
            from_station_name
            ,count(from_station_name)                 as from_total
            ,countif(usertype = 'Subscriber')         as from_subscriber
            ,rank() over(order by countif(usertype = 'Subscriber') desc)  as ranking
      from scooter-sharing44.trips.2019
      group by from_station_name
      order by from_subscriber desc)
where ranking <= 10; 	/* or limit 10, I knooow */

