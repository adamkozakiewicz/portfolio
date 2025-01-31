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




