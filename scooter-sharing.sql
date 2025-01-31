/* Creating a new table with all rides from 2019 */

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


/* Creating a new column for the weekday of the ride's start */

alter table scooter-sharing44.trips.2019 add column day_of_week string;

update scooter-sharing44.trips.2019 
set day_of_week = format_date('%a', start_time) 
where true; 


