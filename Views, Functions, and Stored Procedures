-- CS4400: Introduction to Database Systems: Wednesday, March 8, 2023
-- Flight Management Course Project Mechanics (v1.0) STARTING SHELL
-- Views, Functions & Stored Procedures

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;
set @thisDatabase = 'flight_management';

use flight_management;
-- -----------------------------------------------------------------------------
-- stored procedures and views
-- -----------------------------------------------------------------------------
/* Standard Procedure: If one or more of the necessary conditions for a procedure to
be executed is false, then simply have the procedure halt execution without changing
the database state. Do NOT display any error messages, etc. */

-- [1] add_airplane()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airplane.  A new airplane must be sponsored
by an existing airline, and must have a unique tail number for that airline.
username.  An airplane must also have a non-zero seat capacity and speed. An airplane
might also have other factors depending on it's type, like skids or some number
of engines.  Finally, an airplane must have a database-wide unique location if
it will be used to carry passengers. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airplane;
delimiter //
create procedure add_airplane (in ip_airlineID varchar(50), in ip_tail_num varchar(50),
	in ip_seat_capacity integer, in ip_speed integer, in ip_locationID varchar(50),
    in ip_plane_type varchar(100), in ip_skids boolean, in ip_propellers integer,
    in ip_jet_engines integer)
sp_main: begin
		if ip_locationID is not null and ip_locationID not in (select locationID from location) then
			insert into location values (ip_locationID);
			insert into airplane(airlineID,tail_num,seat_capacity,speed,locationID,plane_type,skids,propellers,jet_engines)
			values(ip_airlineID,ip_tail_num,ip_seat_capacity,ip_speed,ip_locationID,ip_plane_type,ip_skids,ip_propellers,ip_jet_engines);
		elseif ip_locationID is null then 
			insert into airplane(airlineID,tail_num,seat_capacity,speed,locationID,plane_type,skids,propellers,jet_engines)
			values(ip_airlineID,ip_tail_num,ip_seat_capacity,ip_speed,ip_locationID,ip_plane_type,ip_skids,ip_propellers,ip_jet_engines);
		end if;
end //
delimiter ;

-- [2] add_airport()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airport.  A new airport must have a unique
identifier along with a database-wide unique location if it will be used to support
airplane takeoffs and landings.  An airport may have a longer, more descriptive
name.  An airport must also have a city and state designation. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airport;
delimiter //
create procedure add_airport (in ip_airportID char(3), in ip_airport_name varchar(200),
    in ip_city varchar(100), in ip_state char(2), in ip_locationID varchar(50))
sp_main: begin
		if ip_locationID is not null and ip_locationID not in (select locationID from location) then
			insert into location values (ip_locationID);
			insert into airport(airportID,airport_name,city,state,locationID)
			values (ip_airportID,ip_airport_name,ip_city,ip_state,ip_locationID);
		elseif ip_locationID is null then 
			insert into airport(airportID,airport_name,city,state,locationID)
			values (ip_airportID,ip_airport_name,ip_city,ip_state,ip_locationID);
		end if;
end //
delimiter ;

-- [3] add_person()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new person.  A new person must reference a unique
identifier along with a database-wide unique location used to determine where the
person is currently located: either at an airport, or on an airplane, at any given
time.  A person may have a first and last name as well.

Also, a person can hold a pilot role, a passenger role, or both roles.  As a pilot,
a person must have a tax identifier to receive pay, and an experience level.  Also,
a pilot might be assigned to a specific airplane as part of the flight crew.  As a
passenger, a person will have some amount of frequent flyer miles. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_person;
delimiter //
create procedure add_person (in ip_personID varchar(50), in ip_first_name varchar(100),
    in ip_last_name varchar(100), in ip_locationID varchar(50), in ip_taxID varchar(50),
    in ip_experience integer, in ip_flying_airline varchar(50), in ip_flying_tail varchar(50),
    in ip_miles integer)
sp_main: begin
	if ip_locationID in (select locationID from location) then
		insert into person values (ip_personID,ip_first_name,ip_last_name,ip_locationID);
		if ip_taxID is not NUll then
			insert into pilot values (ip_personID,ip_taxID,ip_experience,ip_flying_airline,ip_flying_tail);
		end if;
	end if;
    insert into passenger values (ip_personID,ip_miles);
end //
delimiter ;

-- [4] grant_pilot_license()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new pilot license.  The license must reference
a valid pilot, and must be a new/unique type of license for that pilot. */
-- -----------------------------------------------------------------------------
drop procedure if exists grant_pilot_license;
delimiter //
create procedure grant_pilot_license (in ip_personID varchar(50), in ip_license varchar(100))
sp_main: begin
	if ip_personID in (select personID from pilot) then
		insert into pilot_licenses values (ip_personID, ip_license);
	end if;
end //
delimiter ;

-- [5] offer_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new flight.  The flight can be defined before
an airplane has been assigned for support, but it must have a valid route.  Once
an airplane has been assigned, we must also track where the airplane is along
the route, whether it is in flight or on the ground, and when the next action -
takeoff or landing - will occur. */
-- -----------------------------------------------------------------------------
drop procedure if exists offer_flight;
delimiter //
create procedure offer_flight (in ip_flightID varchar(50), in ip_routeID varchar(50),
    in ip_support_airline varchar(50), in ip_support_tail varchar(50), in ip_progress integer,
    in ip_airplane_status varchar(100), in ip_next_time time)
sp_main: begin
	if ip_routeID in (select routeID from route) then
		if ip_support_tail is null and ip_support_airline is null then
        insert into flight values (ip_flightID, ip_routeID);
        else
			insert into flight values (ip_flightID, ip_routeID, ip_support_airline, ip_support_tail, ip_progress, ip_airplane_status, ip_next_time);
		end if;
	end if;
end //
delimiter ;

-- [6] purchase_ticket_and_seat()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new ticket.  The cost of the flight is optional
since it might have been a gift, purchased with frequent flyer miles, etc.  Each
flight must be tied to a valid person for a valid flight.  Also, we will make the
(hopefully simplifying) assumption that the departure airport for the ticket will
be the airport at which the traveler is currently located.  The ticket must also
explicitly list the destination airport, which can be an airport before the final
airport on the route.  Finally, the seat must be unoccupied. */
-- -----------------------------------------------------------------------------
drop procedure if exists purchase_ticket_and_seat;
delimiter //
create procedure purchase_ticket_and_seat (in ip_ticketID varchar(50), in ip_cost integer,
	in ip_carrier varchar(50), in ip_customer varchar(50), in ip_deplane_at char(3),
    in ip_seat_number varchar(50))
sp_main: begin
	if ip_customer in (select personID from person) and ip_carrier in (select flightID from flight)
    and ip_deplane_at is not null and ip_deplane_at in (select arrival from leg where legID in 
    (select legID from route_path where routeID in (select routeID from flight where flightID = ip_carrier))) then
		insert into ticket values (ip_ticketID, ip_cost, ip_carrier, ip_customer, ip_deplane_at);
		insert into ticket_seats values (ip_ticketID, ip_seat_number);
	end if;
end //
delimiter ;

-- [7] add_update_leg()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new leg as specified.  However, if a leg from
the departure airport to the arrival airport already exists, then don't create a
new leg - instead, update the existence of the current leg while keeping the existing
identifier.  Also, all legs must be symmetric.  If a leg in the opposite direction
exists, then update the distance to ensure that it is equivalent.   */
-- -----------------------------------------------------------------------------
drop procedure if exists add_update_leg;
delimiter //
create procedure add_update_leg (in ip_legID varchar(50), in ip_distance integer,
    in ip_departure char(3), in ip_arrival char(3))
sp_main: begin

if (select legID from leg where departure = ip_departure and arrival = ip_arrival) is null then
insert into leg values (ip_legID, ip_distance, ip_departure, ip_arrival);
else
update leg set distance = ip_distance where departure = ip_departure and arrival = ip_arrival; 
end if;
if (select legID from leg where arrival = ip_departure and departure = ip_arrival) is not null then
update leg set distance = ip_distance where arrival = ip_departure and departure = ip_arrival; end if;

end //
delimiter ;

-- [8] start_route()
-- -----------------------------------------------------------------------------
/* This stored procedure creates the first leg of a new route.  Routes in our
system must be created in the sequential order of the legs.  The first leg of
the route can be any valid leg. */
-- -----------------------------------------------------------------------------
drop procedure if exists start_route;
delimiter //
create procedure start_route (in ip_routeID varchar(50), in ip_legID varchar(50))
sp_main: begin
if ip_legID in (select legID from leg) then
	insert into route values (ip_routeID);
	insert into route_path values(ip_routeID, ip_legID, 1);
end if;
end //
delimiter ;

-- [9] extend_route()
-- -----------------------------------------------------------------------------
/* This stored procedure adds another leg to the end of an existing route.  Routes
in our system must be created in the sequential order of the legs, and the route
must be contiguous: the departure airport of this leg must be the same as the
arrival airport of the previous leg. */
-- -----------------------------------------------------------------------------
drop procedure if exists extend_route;
delimiter //
create procedure extend_route (in ip_routeID varchar(50), in ip_legID varchar(50))
sp_main: begin
	declare test int;
    declare lastleg varchar(50);
    declare airport varchar(50);
	set test = (select sequence from route_path where routeID = ip_routeID order by sequence desc limit 1);
    set lastleg = (select legID from route_path where routeID = ip_routeID order by sequence desc limit 1);
    select arrival into airport from leg where legID = lastleg;
	if (select departure from leg where legID = ip_legID) = airport then 
		insert into route_path values (ip_routeID,ip_legID, test + 1);
	end if;
end //
delimiter ;

-- [10] flight_landing()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight landing at the next airport
along it's route.  The time for the flight should be moved one hour into the future
to allow for the flight to be checked, refueled, restocked, etc. for the next leg
of travel.  Also, the pilots of the flight should receive increased experience, and
the passengers should have their frequent flyer miles updated. */
-- -----------------------------------------------------------------------------
drop procedure if exists flight_landing;
delimiter //
create procedure flight_landing (in ip_flightID varchar(50))
sp_main: begin
declare distance1 integer;
declare airline varchar(50);
declare tail varchar(50);
if (select airplane_status from flight where flightID = ip_flightID) = 'in_flight' then
set airline = (select support_airline from flight where flightID = ip_flightID);
set tail = (select support_tail from flight where flightID = ip_flightID);
update flight set airplane_status = 'on_ground', next_time = addtime(next_time, '01:00:00') where flightID = ip_flightID;
update pilot set experience = experience + 1 where flying_airline = airline and flying_tail = tail;
set distance1 = (select distance from leg where legID in 
(select legID from route_path where routeID in (select routeID from flight where flightID = ip_flightID) and sequence = (select progress from flight where flightID = ip_flightID)));

update passenger set miles = miles + distance1 where personID in (select personID from person where locationID in 
(select locationID from airplane where tail_num in (select support_tail from flight where flightID = ip_flightID)));
end if;
end //
delimiter ;

-- [11] flight_takeoff()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight taking off from its current
airport towards the next airport along it's route.  The time for the next leg of
the flight must be calculated based on the distance and the speed of the airplane.
And we must also ensure that propeller driven planes have at least one pilot
assigned, while jets must have a minimum of two pilots. If the flight cannot take
off because of a pilot shortage, then the flight must be delayed for 30 minutes. */
-- -----------------------------------------------------------------------------
drop procedure if exists flight_takeoff;
delimiter //
create procedure flight_takeoff (in ip_flightID varchar(50))
sp_main: begin
declare airline varchar(50);
declare tail varchar(50);
declare pilots integer;
declare planetype varchar(100);
declare flighttime time;
declare distance1 integer;
declare speed1 integer;
declare hours integer;
declare minutes integer;
if (select airplane_status from flight where flightID = ip_flightID) = 'on_ground' then
set airline = (select support_airline from flight where flightID = ip_flightID);
set tail = (select support_tail from flight where flightID = ip_flightID);
set pilots = (select count(*) from pilot where flying_airline = airline and flying_tail = tail);
set planetype = (select plane_type from airplane where airlineID = airline and tail_num = tail);
if (select progress from flight where flightID = ip_flightID) = 0 then
	set distance1 = (select distance from leg where legID in (select legID from route_path where routeID in 
	(select routeID from flight where flightID = ip_flightID) and sequence = 1));
else
	set distance1 = (select distance from leg where legID in (select legID from route_path where routeID in 
	(select routeID from flight where flightID = ip_flightID) and sequence = (select progress from flight where flightID = ip_flightID)));
end if;
set speed1 = (select speed from airplane where airlineID = airline and tail_num = tail);
if pilots < 1 then 
	update flight set next_time = addtime(next_time, maketime(0,30,0)) where flightID = ip_flightID;
elseif pilots < 2 and planetype = 'jet' then 
	update flight set next_time = addtime(next_time, maketime(0,30,0)) where flightID = ip_flightID;
else 
	set hours = distance1 / speed1;
    set minutes = mod(distance1,speed1);
	update flight set progress = progress + 1, airplane_status = 'in_flight', next_time = addtime(next_time,maketime(hours,minutes,0)) where flightID = ip_flightID;
end if;
end if;
end //
delimiter ;

-- [12] passengers_board()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for passengers getting on a flight at
its current airport.  The passengers must be at the airport and hold a valid ticket
for the flight. */
-- -----------------------------------------------------------------------------
drop procedure if exists passengers_board;
delimiter //
create procedure passengers_board (in ip_flightID varchar(50))
sp_main: begin
declare airport_loc varchar(100);
declare airplane_loc varchar(100);



if (select progress from flight where flightID = ip_flightID) = 0 then
	set airport_loc=(
    select locationID 
    from airport 
    where airportID in (
		select departure 
		from leg where legID in (
			select legID 
			from route_path 
			where routeID in (
				select routeID 
				from flight 
				where flightID = ip_flightID) and sequence =1)));

else 
	set airport_loc=(
		select locationID 
        from airport 
        where airportID in (
			select arrival 
            from leg 
			where legID in (
				select legID 
                from route_path 
                where routeID in (
					select routeID 
                    from flight 
                    where flightID = ip_flightID) and sequence = (
				select progress 
                from flight 
                where flightID = ip_flightID))));

end if;


set airplane_loc = (select locationID from airplane where tail_num in 
(select support_tail from flight where flightID = ip_flightID));

update person set locationID = airplane_loc
where locationID = airport_loc and personID in (select customer from ticket where ticketID in (select ticketID from ticket_seats)
and carrier = ip_flightID);
end //
delimiter ;

-- [13] passengers_disembark()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for passengers getting off of a flight
at its current airport.  The passengers must be on that flight, and the flight must
be located at the destination airport as referenced by the ticket. */
-- -----------------------------------------------------------------------------
drop procedure if exists passengers_disembark;
delimiter //
create procedure passengers_disembark (in ip_flightID varchar(50))
sp_main: begin
declare airport_loc varchar(100);
declare airplane_loc varchar(100);
declare loc_id varchar(100);

set airport_loc=(
		select arrival 
		from leg
		where legID in (
			select legID 
			from route_path 
			where routeID in (
				select routeID 
				from flight 
				where flightID = ip_flightID)
			and sequence = (
				select progress 
                from flight 
                where flightID = ip_flightID)));

set loc_id= (
	select locationID 
    from airport 
    where airportID in (
		select arrival 
		from leg
		where legID in (
			select legID 
			from route_path 
			where routeID in (
				select routeID 
				from flight 
				where flightID = ip_flightID)
			and sequence = (
				select progress 
                from flight 
                where flightID = ip_flightID))));

set airplane_loc = (
	select locationID 
    from airplane 
    where tail_num in (
		select support_tail 
        from flight 
        where flightID = ip_flightID));

if (select airplane_status from flight where flightID = ip_flightID) = 'on_ground' then 
	update person set locationID = loc_id
	where personID in (
		select customer 
        from ticket 
        where carrier = ip_flightID
        and deplane_at = airport_loc);
end if;
end //
delimiter ;

-- [14] assign_pilot()
-- -----------------------------------------------------------------------------
/* This stored procedure assigns a pilot as part of the flight crew for a given
airplane.  The pilot being assigned must have a license for that type of airplane,
and must be at the same location as the flight.  Also, a pilot can only support
one flight (i.e. one airplane) at a time.  The pilot must be assigned to the flight
and have their location updated for the appropriate airplane. */
-- -----------------------------------------------------------------------------
drop procedure if exists assign_pilot;
delimiter //
create procedure assign_pilot (in ip_flightID varchar(50), ip_personID varchar(50))
sp_main: begin
	declare tail varchar(50);
    declare airline varchar(50);
    declare plane varchar(100);
    declare planeloc varchar(50);
    declare airport  varchar(50);
    set airline = (select support_airline from flight where flightID = ip_flightID);
    set tail = (select support_tail from flight where flightID = ip_flightID);
    set plane = (select plane_type from airplane where airlineID = airline and tail_num = tail);
    set planeloc = (select locationID from airplane where airlineID = airline and tail_num = tail);
    set airport = (select locationID from airport where airportID in (select arrival from leg where legID in (select legID from route_path where routeID in
	(select routeID from flight where flightID = ip_flightID)
	and sequence = (select progress from flight where flightID = ip_flightID))));
    if plane in (select license from pilot_licenses where personID = ip_personID)
    and (select locationID from person where personID = ip_personID) = airport then 
		update pilot set flying_airline = airline, flying_tail = tail where personID = ip_personID;
        update person set locationID = planeloc where personID = ip_personID;
	end if;
end //
delimiter ;

-- [15] recycle_crew()
-- -----------------------------------------------------------------------------
/* This stored procedure releases the assignments for a given flight crew.  The
flight must have ended, and all passengers must have disembarked. */
-- -----------------------------------------------------------------------------
drop procedure if exists recycle_crew;
delimiter //
create procedure recycle_crew (in ip_flightID varchar(50))
sp_main: begin
DECLARE flightProgress INT;
DECLARE crewCount INT;
declare lastleg varchar(50);
declare loc varchar(50);
declare airline varchar(50);
declare tail varchar(50);
set airline = (select support_airline from flight where flightID = ip_flightID);
set tail = (select support_tail from flight where flightID = ip_flightID);
    SELECT progress INTO flightProgress FROM flight WHERE flightID = ip_flightID;

    IF flightProgress < (select sequence from route_path where routeID in 
    (select routeID from flight where flightID = ip_flightID) order by sequence desc limit 1) or 
    (select locationID from airplane where airlineID = airline and tail_num = tail) in (select locationID from person where personID not in (select personID from pilot)) THEN
        select 'The flight has not been completed yet.';
    ELSE
        -- Check if any crew member is still assigned to the flight
        SELECT COUNT(*) INTO crewCount
        FROM pilot
        WHERE flying_airline in (select support_airline from flight where flightID = ip_flightID)
        and flying_tail in (select support_tail from flight where flightID = ip_flightID);

        IF crewCount > 0 THEN
            -- Release the assignments for the crew members
            set lastleg = (select legID from route_path where routeID in 
            (select routeID from flight where flightID = ip_flightID) order by sequence desc limit 1);
            
            update person 
            set locationID = (select locationID from airport where airportID in (select arrival from leg where legID = lastleg))
            Where personID in (select personID from pilot WHERE flying_airline in (select support_airline from flight where flightID = ip_flightID)
			and flying_tail in (select support_tail from flight where flightID = ip_flightID));
            
            UPDATE pilot
            SET flying_airline = NULL, flying_tail = null
            WHERE flying_airline in (select support_airline from flight where flightID = ip_flightID)
			and flying_tail in (select support_tail from flight where flightID = ip_flightID);
            

            
            SELECT 'Assignments released for flight crew.';
        ELSE
            SELECT 'No crew members found with the specified IDs and location.';
        END IF;
    END IF;

end //
delimiter ;

-- [16] retire_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure removes a flight that has ended from the system.  The
flight must be on the ground, and either be at the start its route, or at the
end of its route.  */
-- -----------------------------------------------------------------------------
drop procedure if exists retire_flight;
delimiter //
create procedure retire_flight (in ip_flightID varchar(50))
sp_main: begin
declare flightProgress int;
SELECT progress INTO flightProgress FROM flight WHERE flightID = ip_flightID;
IF (flightProgress >= (select sequence from route_path where routeID in 
    (select routeID from flight where flightID = ip_flightID) order by sequence desc limit 1) or 
    flightProgress = 0) and (select airplane_status from flight where flightID = ip_flightID) = 'on_ground' THEN
		delete from flight where flightID = ip_flightID;
end if;
end //
delimiter ;

-- [17] remove_passenger_role()
-- -----------------------------------------------------------------------------
/* This stored procedure removes the passenger role from person.  The passenger
must be on the ground at the time; and, if they are on a flight, then they must
disembark the flight at the current airport.  If the person had both a pilot role
and a passenger role, then the person and pilot role data should not be affected.
If the person only had a passenger role, then all associated person data must be
removed as well. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_passenger_role;
delimiter //
create procedure remove_passenger_role (in ip_personID varchar(50))
sp_main: begin
declare ticket varchar(50);
declare status1 varchar(50);
declare nextport varchar(50);
declare currloc varchar(50);
set status1 = (select airplane_status from flight where flightID in (select carrier from ticket where customer = ip_personID));
set currloc = (select locationID from person where personID = ip_personID);
if currloc like '%plane%' then
	if status1 = 'on_ground' then
			 /*if ((select progress from flight where flightID in (select carrier from ticket where customer = ip_personID)) = 0) then
				set nextport = (select departure from leg where legID in (select legID from route_path where routeID in
				(select routeID from flight where flightID in (select carrier from ticket where customer = ip_personID)) and sequence = 1));
            else 
				set nextport = (select arrival from leg where legID in (select legID from route_path where routeID in
				(select routeID from flight where flightID in (select carrier from ticket where customer = ip_personID)) and sequence = (select progress from flight where flightID in (select carrier from ticket where customer = ip_personID))));
			end if; */
		if ip_personID in (select personID from pilot) then
			/*update person set locationID = (select locationID from airport where airportID = nextport) where personID = ip_personID; */
            delete from ticket_seats where ticketID in (select ticketID from ticket where customer = ip_personID);
            delete from ticket where customer = ip_personID;
            delete from passenger where personID = ip_personID;
		else 
			delete from ticket_seats where ticketID in (select ticketID from ticket where customer = ip_personID);
			delete from ticket where customer = ip_personID;
			delete from passenger where personID = ip_personID;
            delete from person where personID = ip_personID;
		end if;
	end if;
else
	if ip_personID in (select personID from pilot) then
			/*update person set locationID = (select locationID from airport where airportID = nextport) where personID = ip_personID;*/
            delete from ticket_seats where ticketID in (select ticketID from ticket where customer = ip_personID);
            delete from ticket where customer = ip_personID;
            delete from passenger where personID = ip_personID;
		else 
			delete from ticket_seats where ticketID in (select ticketID from ticket where customer = ip_personID);
			delete from ticket where customer = ip_personID;
			delete from passenger where personID = ip_personID;
            delete from person where personID = ip_personID;
		end if;
end if;
end //
delimiter ;

-- [18] remove_pilot_role()
-- -----------------------------------------------------------------------------
/* This stored procedure removes the pilot role from person.  The pilot must not
be assigned to a flight; or, if they are assigned to a flight, then that flight
must either be at the start or end of its route.  If the person had both a pilot
role and a passenger role, then the person and passenger role data should not be
affected.  If the person only had a pilot role, then all associated person data
must be removed as well. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_pilot_role;
delimiter //
create procedure remove_pilot_role (in ip_personID varchar(50))
sp_main: begin
declare flight_progress varchar(100);
declare max_progress varchar(100);
declare flight_airline varchar(100);
declare flight_tail varchar(100);
declare flight varchar(50);



set flight_progress = (select progress from flight where (support_airline, support_tail)
in (select flying_airline, flying_tail from pilot where personID=ip_personID));
set max_progress = (select max(sequence)from route_path where routeID in (select routeID from flight where
(support_airline, support_tail) in (select flying_airline, flying_tail from pilot where personID = ip_personID)));
set flight_airline = (select flying_airline from pilot where personID = ip_personID);
set flight_tail = (select flying_tail from pilot where personID = ip_personID);
set flight = ((select flightID from flight where support_airline = flight_airline and support_tail = flight_tail));
if (flight_airline is null and flight_tail is null) or
(flight is null)
or (flight_progress=0 or flight_progress>=max_progress) then 
	delete from pilot_licenses where personID = ip_personID;
    delete from pilot where personID = ip_personID;
	if ip_personID not in (select personID from passenger) then
		delete from person where personID = ip_personID;
	end if;
end if;
end //
delimiter ;

-- [19] flights_in_the_air()
-- -----------------------------------------------------------------------------
/* This view describes where flights that are currently airborne are located. */
-- -----------------------------------------------------------------------------
create or replace view flights_in_the_air (departing_from, arriving_at, num_flights,
	flight_list, earliest_arrival, latest_arrival, airplane_list) as
SELECT 
    l.departure AS departing_from,
    l.arrival AS arriving_at,
    COUNT(*) AS num_flights,
    GROUP_CONCAT(DISTINCT f.flightID) AS flight_list,
    MIN(f.next_time) AS earliest_arrival,
    MAX(f.next_time) AS latest_arrival,
    GROUP_CONCAT(DISTINCT a.locationID) AS airplane_list
FROM flight f
JOIN route_path rp ON f.routeID = rp.routeID AND f.progress = rp.sequence
JOIN leg l ON rp.legID = l.legID
LEFT JOIN airplane a ON f.support_tail = a.tail_num
WHERE f.airplane_status = 'in_flight' 
GROUP BY l.departure, l.arrival;


-- [20] flights_on_the_ground()
-- -----------------------------------------------------------------------------
/* This view describes where flights that are currently on the ground are located. */
-- -----------------------------------------------------------------------------
create or replace view flights_on_the_ground (departing_from, num_flights,
	flight_list, earliest_arrival, latest_arrival, airplane_list) as 
SELECT
    l.departure AS departing_from,
    COUNT(*) AS num_flights,
    GROUP_CONCAT(f.flightID) AS flight_list,
    MIN(f.next_time) AS earliest_arrival,
    MAX(f.next_time) AS latest_arrival,
    a.locationID AS airplane_list
FROM
    flight f
JOIN
    airplane a ON f.support_tail = a.tail_num
JOIN
    route_path rp ON f.routeID = rp.routeID AND f.progress = rp.sequence - 1
JOIN
    leg l ON rp.legID = l.legID
WHERE
    f.airplane_status = 'on_ground'
GROUP BY
    l.departure, a.locationID;


-- [21] people_in_the_air()
-- -----------------------------------------------------------------------------
/* This view describes where people who are currently airborne are located. */
-- -----------------------------------------------------------------------------
create or replace view people_in_the_air (departing_from, arriving_at, num_airplanes,
	airplane_list, flight_list, earliest_arrival, latest_arrival, num_pilots,
	num_passengers, joint_pilots_passengers, person_list) as
select l.departure as departing_from,
    l.arrival as arriving_at, COUNT(distinct a.locationID) as num_airplanes,
    GROUP_CONCAT(DISTINCT a.locationID) AS airplane_list,
    GROUP_CONCAT(DISTINCT f.flightID) AS flight_list,
    MIN(f.next_time) AS earliest_arrival,
    MAX(f.next_time) AS latest_arrival,
    count(distinct pi.personID),
    count(distinct pa.personID),
    count(*),
    group_concat(distinct p.personID)
FROM flight f
JOIN route_path rp ON f.routeID = rp.routeID AND f.progress = rp.sequence
JOIN leg l ON rp.legID = l.legID
LEFT JOIN airplane a ON f.support_tail = a.tail_num
join person as p on p.locationID = a.locationID
left join pilot as pi on p.personID = pi.personID
left join passenger as pa on p.personID = pa.personID
WHERE f.airplane_status = 'in_flight' 
GROUP BY l.departure, l.arrival;

-- [22] people_on_the_ground()
-- -----------------------------------------------------------------------------
/* This view describes where people who are currently on the ground are located. */
-- -----------------------------------------------------------------------------
create or replace view people_on_the_ground (departing_from, airport, airport_name,
	city, state, num_pilots, num_passengers, joint_pilots_passengers, person_list) as
select a.airportID as departing_from,
	a.locationID,
	a.airport_name,
    a.city,
    a.state,
    count(distinct pi.personID),
    count(distinct pa.personID),
    count(*),
    group_concat(distinct p.personID order by p.personID)
FROM airport as a
join person as p on p.locationID = a.locationID
left join pilot as pi on p.personID = pi.personID
left join passenger as pa on p.personID = pa.personID 
GROUP BY a.airportId;

-- [23] route_summary()
-- -----------------------------------------------------------------------------
/* This view describes how the routes are being utilized by different flights. */
-- -----------------------------------------------------------------------------
create or replace view route_summary (route, num_legs, leg_sequence, route_length,
	num_flights, flight_list, airport_sequence) as
select tablea.routeID,numlegs,legsequence, distance,count(flightID), group_concat((tabled.flightID) order by tabled.flightID),airportsequence from 
(select route.routeID, count(legID)as numlegs, GROUP_CONCAT((legID) order by sequence) as legsequence, 
sum(distance) as distance, group_concat((concat(departure, '->',arrival)) order by sequence) as airportsequence from route left outer join (route_path
natural join leg) on route.routeID = route_path.routeID  group by routeID) as tablea 
left outer join (select distinct flightID, routeID from flight) as tabled on tablea.routeID = tabled.routeID 
group by routeID;

-- [24] alternative_airports()
-- -----------------------------------------------------------------------------
/* This view displays airports that share the same city and state. */
-- -----------------------------------------------------------------------------
create or replace view alternative_airports (city, state, num_airports,
	airport_code_list, airport_name_list) as
SELECT city, state, COUNT(*) AS num_airports_shared, 
GROUP_CONCAT(airportID ORDER BY airportID ASC) AS airport_code_list,
GROUP_CONCAT(airport_name ORDER BY airportID ASC) AS airport_name_list
FROM airport
GROUP BY city, state
HAVING COUNT(*) > 1;


-- [25] simulation_cycle()
-- -----------------------------------------------------------------------------
/* This stored procedure executes the next step in the simulation cycle.  The flight
with the smallest next time in chronological order must be identified and selected.
If multiple flights have the same time, then flights that are landing should be
preferred over flights that are taking off.  Similarly, flights with the lowest
identifier in alphabetical order should also be preferred.

If an airplane is in flight and waiting to land, then the flight should be allowed
to land, passengers allowed to disembark, and the time advanced by one hour until
the next takeoff to allow for preparations.

If an airplane is on the ground and waiting to takeoff, then the passengers should
be allowed to board, and the time should be advanced to represent when the airplane
will land at its next location based on the leg distance and airplane speed.

If an airplane is on the ground and has reached the end of its route, then the
flight crew should be recycled to allow rest, and the flight itself should be
retired from the system. */
-- -----------------------------------------------------------------------------
drop procedure if exists simulation_cycle;
delimiter //
create procedure simulation_cycle ()
sp_main: begin
	declare flight varchar(50);
    declare routeprogress integer;
    declare stat varchar(100);
    declare routeend int;
    set flight = (select flightID from flight where next_time is not null order by (next_time) asc,airplane_status asc, flightID asc limit 1);
    set routeprogress = (select progress from flight where next_time is not null order by (next_time) asc,airplane_status asc, flightID asc limit 1);
    set stat = (select airplane_status from flight where next_time is not null order by (next_time) asc,airplane_status asc, flightID asc limit 1);
    set routeend = (select sequence from route_path where routeID in (select routeID from flight where flightID = flight) order by sequence desc limit 1);
    if stat = 'in_flight' then
		call flight_landing(flight);
        call passengers_disembark(flight);
	else
		if routeprogress = routeend then
			call recycle_crew(flight);
            call retire_flight(flight);
		else
			call passengers_board(flight);
            call flight_takeoff(flight);
		end if;
	end if;
end //
delimiter ;

