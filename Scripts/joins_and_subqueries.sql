--How can you produce a list of the start times for bookings by members named 'David Farrell'?
select b.starttime
from cd.bookings b 
     join cd.members m
     on b.memid = m.memid
where m.firstname = 'David'
  and m.surname = 'Farrell';
 
 
 --How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? 
 --Return a list of start time and facility name pairings, ordered by the time.
select b.starttime as start, f.name
from cd.bookings b 
     join cd.facilities f
     on b.facid = f.facid
where date(b.starttime) = '2012-09-21'
  and f.name like 'Tennis Court%'
 order by start;

--How can you output a list of all members who have recommended another member? 
--Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname). 
select distinct m1.firstname, m1.surname
from cd.members m1
     join cd.members m2
     on m1.memid = m2.recommendedby
order by m1.surname, m1.firstname;

select firstname, surname
from cd.members
where memid in
      (select distinct recommendedby
       from cd.members)
order by surname, firstname;


--How can you output a list of all members, including the individual who recommended them (if any)? 
--Ensure that results are ordered by (surname, firstname). 
select distinct m1.firstname as memfname, 
       m1.surname as memsname, 
       m2.firstname as recfname, 
       m2.surname as recsname
from cd.members m1
     left join cd.members m2
     on m1.recommendedby = m2.memid
order by memsname, memfname;


--How can you produce a list of all members who have used a tennis court? 
--Include in your output the name of the court, and the name of the member formatted
--as a single column. Ensure no duplicate data, and order by the member name. 
select distinct m.firstname || ' ' || m.surname as member,
       f.name as facility
from cd.members m 
     join cd.bookings b
       on m.memid = b.memid
     join cd.facilities f 
       on b.facid = f.facid
where f.name like 'Tennis Court%'
order by member;
    

--How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest)
-- more than $30? Remember that guests have different costs to members 
--(the listed costs are per half-hour 'slot'), and the guest user is always ID 0. 
--Include in your output the name of the facility, the name of the member formatted as a single column,
--and the cost. Order by descending cost, and do not use any subqueries. 
select m.firstname || ' ' || m.surname as member,
       f.name as facility, 
       case when m.memid = 0 then b.slots * f.guestcost
            else b.slots * f.membercost end as cost
from cd.members m 
     join cd.bookings b
       on m.memid = b.memid
     join cd.facilities f 
       on b.facid = f.facid
where date(b.starttime) = '2012-09-14'
and (case when m.memid = 0 then b.slots * f.guestcost
            else b.slots * f.membercost end) > 30
order by cost desc;


--How can you output a list of all members, including the individual who recommended them (if any), 
--without using any joins? Ensure that there are no duplicates in the list, and that each 
--firstname + surname pairing is formatted as a column and ordered. 
select distinct m1.firstname || ' ' || m1.surname as member,
        (select m2.firstname || ' ' || m2.surname as recommender
        from cd.members m2
        where m2.memid = m1.recommendedby)
from cd.members m1
order by member;


--How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest)
-- more than $30? Remember that guests have different costs to members 
--(the listed costs are per half-hour 'slot'), and the guest user is always ID 0. 
--Include in your output the name of the facility, the name of the member formatted as a single column,
--and the cost. Order by descending cost - use subqueries. 
select member, facility, cost from 
(select m.firstname || ' ' || m.surname as member,
       f.name as facility, 
       case when m.memid = 0 then b.slots * f.guestcost
            else b.slots * f.membercost end as cost
from cd.members m 
     join cd.bookings b
       on m.memid = b.memid
     join cd.facilities f 
       on b.facid = f.facid
where date(b.starttime) = '2012-09-14') as bookings
where cost > 30
order by cost desc;




 
 
 
 