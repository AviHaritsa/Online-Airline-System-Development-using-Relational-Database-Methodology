-- CS4400: Introduction to Database Systems: Monday, January 30, 2023
-- Flight Management Course Project Database TEMPLATE (v1.0)

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;
set @thisDatabase = 'flight_management';

drop database if exists flight_management;
create database if not exists flight_management;
use flight_management;

-- Define the database structures and enter the denormalized data
drop table if exists Locations;
create table Locations (
LocID varchar(50) NOT NULL,
primary key (locID)
);
drop table if exists Airports;
create table Airports (
airportID char(3) primary key,
airport_Name varchar(100) NOT NULL,
airport_City varchar(50) NOT NULL,
airport_State char(2) NOT NULL,
locationID varchar(50),
foreign key (locationID) references Locations(locID)
);
drop table if exists legs;
CREATE TABLE legs (
    legID varchar(50) PRIMARY KEY,
    distance int NOT NULL,
    departs_from char(3) NOT NULL,
    FOREIGN KEY (departs_from) REFERENCES airports(airportID),
    arrives_at char(3) NOT NULL,
    FOREIGN KEY (arrives_at) REFERENCES airports(airportID)
);
drop table if exists Airlines;
CREATE TABLE Airlines (
    airlineID varchar (50) primary key,
    revenue int
); 

drop table if exists Airplanes;
CREATE TABLE Airplanes (
    airlineID varchar (50) NOT NULL,
    tail_num varchar (50) check (tail_num Rlike 'n[0-9]{3}[a-z]{2}') NOT NULL,
    seat_capacity int NOT NULL,
    speed int NOT NULL,
    locationID varchar (50),
    plane_type varchar(10),
    skids bit(1),
    props_or_jets int,
    PRIMARY KEY (airlineID, tail_num),
    FOREIGN KEY (airlineID) references Airlines (airlineID),
    FOREIGN KEY (locationID) references Locations(locID)
);


drop table if exists Persons;
create table Persons (
personID varchar(50) primary key,
first_name varchar(100) NOT NULL,
last_name varchar(100),
LocationID varchar(50) NOT NULL, 
tax_id char(11) check (tax_id Rlike '[0-9]{3}-[0-9]{2}-[0-9]{3}'),
experience int,
fliesAirline varchar(50),
fliesTailNo varchar(50),  
miles int,
foreign key (locationID) references Locations(locID),
foreign key (fliesAirLine, fliesTailNo) references Airplanes(airlineID,tail_num)
);

drop table if exists routes;
create table routes (
routeID varchar(80) primary key
    );

drop table if exists flights;
create table flights (
	flightID varchar(50) primary key NOT NULL,
    route varchar(50) NOT NULL,
    supportingAirline varchar(50),
    supportingPlane varchar(50),
    progress int,
    current_status varchar(50),
    nextTime time,
    foreign key (route) references routes(routeID),
    foreign key (supportingAirline,supportingPlane) references Airplanes(AirlineID,tail_num)
);
drop table if exists tickets;
CREATE TABLE tickets (
    ticketID varchar(50) primary key,
    cost int default 0,
    carrier varchar(50) NOT NULL,
    customer varchar(50) NOT NULL,
    deplanes varchar(50)NOT NULL,
    FOREIGN KEY (carrier) REFERENCES flights(FlightID),
    FOREIGN KEY (customer) REFERENCES persons(personID),
    FOREIGN KEY (deplanes) REFERENCES airports(airportID)
);

drop table if exists pilotLicenses;
create table pilotLicenses (
	person varchar(50) NOT NULL,
	license_name varchar(50) NOT NULL,
    foreign key (person) references Persons(personID)
);

drop table if exists ticketSeat;
create table ticketSeat (
    ticketID varchar(50) not null,
    t_seat varchar(10) not null,
    foreign key (ticketID) references tickets(ticketID)
);

drop table if exists routecontains;
create table routecontains (
    routeID varchar(50) not null,
    legID varchar(50),
    sequence int,
    foreign key (routeID) references routes(routeID),
    foreign key (legID) references legs(legID)
);

/* insert statements*/
INSERT INTO locations VALUES
('plane_1'),
('plane_11'),
('plane_15'),
('plane_2'),
('plane_4'),
('plane_7'),
('plane_8'),
('plane_9'),
('port_1'),
('port_10'),
('port_11'),
('port_13'),
('port_14'),
('port_15'),
('port_17'),
('port_18'),
('port_2'),
('port_3'),
('port_4'),
('port_5'),
('port_7'),
('port_9');
INSERT INTO Airports VALUES
('ABQ', 'Albuquerque International Sunport', 'Albuquerque', 'NM', NULL),
('ANC', 'Ted Stevens Anchorage International Airport', 'Anchorage', 'AK', NULL),
('ATL', 'Hartsfield-Jackson Atlanta International Airport', 'Atlanta', 'GA', 'port_1'),
('BDL', 'Bradley International Airport', 'Hartford', 'CT', NULL),
('BFI', 'King County International Airport', 'Seattle', 'WA', 'port_10'),
('BHM', 'Birmingham-Shuttlesworth International Airport', 'Birmingham', 'AL',NULL),
('BNA', 'Nashville International Airport', 'Nashville', 'TN', NULL),
('BOI', 'Boise Airport', 'Boise', 'ID', NULL),
('BOS', 'General Edward Lawrence Logan International Airport', 'Boston', 'MA', NULL),
('BTV', 'Burlington International Airport', 'Burlington', 'VT', NULL),
('BWI', 'Baltimore_Washington International Airport', 'Baltimore', 'MD', NULL),
('BZN', 'Bozeman Yellowstone International Airport', 'Bozeman', 'MT', NULL),
('CHS', 'Charleston International Airport', 'Charleston', 'SC', NULL),
('CLE', 'Cleveland Hopkins International Airport', 'Cleveland', 'OH', NULL),
('CLT', 'Charlotte Douglas International Airport', 'Charlotte', 'NC', NULL),
('CRW', 'Yeager Airport', 'Charleston', 'WV', NULL),
('DAL', 'Dallas Love Field', 'Dallas', 'TX', 'port_7'),
('DCA', 'Ronald Reagan Washington National Airport', 'Washington', 'DC', 'port_9'),
('DEN', 'Denver International Airport', 'Denver', 'CO', 'port_3'),
('DFW', 'Dallas-Fort Worth International Airport', 'Dallas', 'TX', 'port_2'),
('DSM', 'Des Moines International Airport', 'Des Moines', 'IA', NULL),
('DTW', 'Detroit Metro Wayne County Airport', 'Detroit', 'MI', NULL),
('EWR', 'Newark Liberty International Airport', 'Newark', 'NJ', NULL),
('FAR', 'Hector International Airport', 'Fargo', 'ND', NULL),
('FSD', 'Joe Foss Field', 'Sioux Falls', 'SD', NULL),
('GSN', 'Saipan International Airport', 'Obyan Saipan Island', 'MP', NULL),
('GUM', 'Antonio B_Won Pat International Airport', 'Agana Tamuning', 'GU', NULL),
('HNL', 'Daniel K. Inouye International Airport', 'Honolulu Oahu', 'HI', NULL),
('HOU', 'William P_Hobby Airport', 'Houston', 'TX', 'port_18'),
('IAD', 'Washington Dulles International Airport', 'Washington', 'DC', 'port_11'),
('IAH', 'George Bush Intercontinental Houston Airport', 'Houston', 'TX', 'port_13'),
('ICT', 'Wichita Dwight D_Eisenhower National Airport', 'Wichita', 'KS', NULL),
('ILG', 'Wilmington Airport', 'Wilmington', 'DE', NULL),
('IND', 'Indianapolis International Airport', 'Indianapolis', 'IN', NULL),
('ISP', 'Long Island MacArthur Airport', 'New York Islip', 'NY', 'port_14'),
('JAC', 'Jackson Hole Airport', 'Jackson', 'WY', NULL),
('JAN', 'Jackson_Medgar Wiley Evers International Airport', 'Jackson', 'MS', NULL),
('JFK', 'John F_Kennedy International Airport', 'New York', 'NY', 'port_15'),
('LAS', 'Harry Reid International Airport', 'Las Vegas', 'NV', NULL),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'CA', 'port_5'),
('LGA', 'LaGuardia Airport', 'New York', 'NY', NULL),
('LIT', 'Bill and Hillary Clinton National Airport', 'Little Rock', 'AR', NULL),
('MCO', 'Orlando International Airport', 'Orlando', 'FL', NULL),
('MDW', 'Chicago Midway International Airport', 'Chicago', 'IL', NULL),
('MHT', 'Manchester_Boston Regional Airport', 'Manchester', 'NH', NULL),
('MKE', 'Milwaukee Mitchell International Airport', 'Milwaukee', 'WI', NULL),
('MRI', 'Merrill Field', 'Anchorage', 'AK', NULL),
('MSP', 'Minneapolis_St_Paul International Wold_Chamberlain Airport', 'Minneapolis Saint Paul',
 'MN', NULL),
('MSY', 'Louis Armstrong New Orleans International Airport', 'New Orleans', 'LA', NULL),
('OKC', 'Will Rogers World Airport', 'Oklahoma City', 'OK', NULL),
('OMA', 'Eppley Airfield', 'Omaha', 'NE', NULL),
('ORD', 'O_Hare International Airport', 'Chicago', 'IL', 'port_4'),
('PDX', 'Portland International Airport', 'Portland', 'OR', NULL),
('PHL', 'Philadelphia International Airport', 'Philadelphia', 'PA', NULL),
('PHX', 'Phoenix Sky Harbor International Airport', 'Phoenix', 'AZ', NULL),
('PVD', 'Rhode Island T_F_Green International Airport', 'Providence', 'RI', NULL),
('PWM', 'Portland International Jetport', 'Portland', 'ME', NULL),
('SDF', 'Louisville International Airport', 'Louisville', 'KY', NULL),
('SEA', 'Seattle-Tacoma International Airport', 'Seattle Tacoma', 'WA', 'port_17'),
('SJU', 'Luis Munoz Marin International Airport', 'San Juan Carolina', 'PR', NULL),
('SLC', 'Salt Lake City International Airport', 'Salt Lake City', 'UT', NULL),
('STL', 'St_Louis Lambert International Airport', 'Saint Louis', 'MO', NULL),
('STT', 'Cyril E_King Airport', 'Charlotte Amalie Saint Thomas', 'VI', NULL);

INSERT INTO Airlines VALUES
('Air_France',	 25),
('American', 45),
('Delta',  46),
('JetBlue', 8),
('Lufthansa', 31),
('Southwest', 22),
('Spirit', 4),
('United', 40);

INSERT INTO Airplanes VALUES
('American', 'n330ss', 4, 200, 'plane_4',  'jet', NULL, 2),
('American', 'n380sd', 5, 400,  NULL, 'jet', NULL, 2),
('Delta', 'n106js', 4, 200, 'plane_1', 'jet', NULL, 2),
('Delta', 'n110jn', '5','600', 'plane_2', 'jet', NULL, 4),
('Delta', 'n127js', 4, 800, NULL, NULL, NULL,NULL),				
('Delta', 'n156sq', 8, 100, NULL, NULL, NULL,NULL), 
('JetBlue', 'n161fk', 4, 200, NULL, 'jet', NULL, 2), 
('JetBlue', 'n337as', 5, 400, NULL, 'jet', NULL, 2),
('Southwest', 'n118fm', 4, 100, 'plane_11', 'prop', 1, 1),
('Southwest', 'n401fj'	, 4, 200, 'plane_9',  'jet', NULL, 2),
('Southwest', 'n653fk', 6, 400, NULL, 'jet', NULL, 2),
('Southwest', 'n815pw', 3, 200, NULL, 'prop', 0, 2),
('Spirit', 'n256ap', 4, 400, 'plane_15', 'jet', NULL, 2),
('United', 'n451fi', 5, 400, NULL, 'jet', NULL, 4),
('United', 'n517ly', 4,	 400, 'plane_7', 'jet', NULL, 2),
('United', 'n616lt', 7, 400, NULL, 'jet', NULL, 4),
('United', 'n620la', 4, 200, 'plane_8', 'prop', 0, 2);

INSERT INTO legs VALUES
('leg_11', 600,	 'IAD', 'ORD'),
('leg_13', 1400, 'IAH', 'LAX'),
('leg_14', 2400, 'ISP', 'BFI'),
('leg_15', 800,	 'JFK', 'ATL'),
('leg_2', 600, 'ATL', 'IAH'),
('leg_5', 1000,	 'BFI', 'LAX'),
('leg_4', 600, 'ATL', 'ORD'),
('leg_20', 600, 'ORD', 'DCA'),
('leg_7', 600, 'DCA', 'ATL'),
('leg_18', 1200, 'LAX', 'DFW'),
('leg_10', 800, 'DFW', 'ORD'),
('leg_22', 800, 'ORD', 'LAX'),
('leg_24', 1800, 'SEA', 'ORD'),
('leg_8', 200, 'DCA', 'JFK'),
('leg_23', 2400, 'SEA', 'JFK'),
('leg_9', 800, 'DFW', 'ATL'),
('leg_1', 600, 'ATL', 'IAD'),
('leg_25', 600, 'ORD', 'ATL'),
('leg_26', 800, 'LAX', 'ORD'),
('leg_12', 200, 'IAH', 'DAL'),
('leg_6', 200, 'DAL', 'HOU'),
('leg_3', 800, 'ATL', 'JFK'),
('leg_19', 1000, 'LAX', 'SEA'),
('leg_21', 800, 'ORD', 'DFW'),
('leg_16', 800, 'JFK', 'ORD'),
('leg_17', 2400, 'JFK', 'SEA'),
('leg_27', 1600, 'ATL', 'LAX');


INSERT INTO routes VALUES
('circle_east_coast'),
('circle_west_coast'),
('eastbound_north_milk_run'),
('eastbound_north_nonstop'),
('eastbound_south_milk_run'),
('hub_xchg_southeast'),
('hub_xchg_southwest'),
('local_texas'),
('northbound_east_coast'),
('northbound_west_coast'),
('southbound_midwest'),
('westbound_north_milk_run'),
('westbound_north_nonstop'),
('westbound_south_nonstop');

INSERT INTO flights VALUES
('AM_1523', 'circle_west_coast', 'American', 'n330ss', 2, 'on_ground', time('14:30:00')),
('DL_1174', 'northbound_east_coast', 'Delta', 'n106js', 0, 'on_ground', time('08:00:00')),
('DL_1243', 'westbound_north_nonstop', 'Delta', 'n110jn', 0, 'on_ground', time('09:30:00')),
('DL_3410', 'circle_east_coast', NULL, NULL, NULL, NULL, NULL),
('SP_1880', 'circle_east_coast', 'Spirit', 'n256ap', 2, 'in_flight', time('15:00:00')),
('SW_1776', 'hub_xchg_southwest','Southwest', 'n401fj',	 2, 'In_flight', time('14:00:00')),
('SW_610', 'local_texas', 'Southwest', 'n118fm', 2, 'in_flight', time('11:30:00')),
('UN_1899', 'eastbound_north_milk_run', 'United', 'n517ly', 0, 'on_ground', time('09:30:00')),
('UN_523', 'hub_xchg_southeast', 'United', 'n620la', 1, 'in_flight', time('11:00:00')),
('UN_717', 'circle_west_coast', NULL, NULL, NULL, NULL, NULL);


Insert into Persons values
('p1', 'Jeanne', 'Nelson', 'plane_1', '330-12-6907', 31.0, 'Delta', 'n106js', null),
('p10', 'Lawrence', 'Morgan', 'plane_9', '769-60-1266', 15.0, 'Southwest', 'n401fj', null),
('p11', 'Sandra', 'Cruz', 'plane_9', '369-22-9505', 22.0, 'Southwest', 'n401fj', null), 
('p12', 'Dan', 'Ball', 'plane_11', '680-92-5329', 24.0, 'Southwest', 'n118fm', null), 
('p13', 'Bryant', 'Figueroa', 'plane_2', '513-40-4168', 24.0, 'Delta', 'n110jn', null),
('p14', 'Dana', 'Perry', 'plane_2', '454-71-7847', 13.0, 'Delta', 'n110jn', null),
('p15', 'Matt', 'Hunt', 'plane_2', '153-47-8101', 30.0, 'Delta', 'n110jn', null), 
('p16', 'Edna', 'Brown', 'plane_15', '598-47-5172', 28.0, 'Spirit', 'n256ap', null), 
('p17', 'Ruby', 'Burgess', 'plane_15', '865-71-6800', 36.0, 'Spirit', 'n256ap', null), 
('p18', 'Esther', 'Pittman', 'port_2', '250-86-2784', 23.0, null, null, null), 
('p19', 'Doug', 'Fowler', 'port_4', '386-39-7881', 2.0, null, null, null), 
('p2', 'Roxanne', 'Byrd', 'plane_1', '842-88-1257', 9.0, 'Delta', 'n106js', null), 
('p20', 'Thomas', 'Olson', 'port_3', '522-44-3098', 28.0, null, null, null), 
('p21', 'Mona', 'Harrison', 'port_4', '621-34-5755', 2.0, null, null, 771.0), 
('p22', 'Arlene', 'Massey', 'port_2', '177-47-9877', 3.0, null, null, 374.0), 
('p23', 'Judith', 'Patrick', 'port_3', '528-64-7912', 12.0, null, null, 414.0), 
('p24', 'Reginald', 'Rhodes', 'plane_1', '803-30-1789', 34.0, null, null, 292.0), 
('p25', 'Vincent', 'Garcia', 'plane_1', '986-76-1587', 13.0, null, null, 390.0), 
('p26', 'Cheryl', 'Moore', 'plane_4', '584-77-5105', 20.0, null, null, 302.0), 
('p27', 'Michael', 'Rivera', 'plane_7', null, null, null, null, 470.0), 
('p28', 'Luther', 'Matthews', 'plane_8', null, null, null, null, 208.0), 
('p29', 'Moses', 'Parks', 'plane_8', null, null, null, null, 292.0), 
('p3', 'Tanya', 'Nguyen', 'plane_4', '750-24-7616', 11.0, 'American', 'n330ss', null), 
('p30', 'Ora', 'Steele', 'plane_9', null, null, null, null, 686.0), 
('p31', 'Antonio', 'Flores', 'plane_9', null, null, null, null, 547.0), 
('p32', 'Glenn', 'Ross', 'plane_11', null, null, null, null, 257.0), 
('p33', 'Irma', 'Thomas', 'plane_11', null, null, null, null, 564.0), 
('p34', 'Ann', 'Maldonado', 'plane_2', null, null, null, null, 211.0),
('p35', 'Jeffrey', 'Cruz', 'plane_2', null, null, null, null, 233.0), 
('p36', 'Sonya', 'Price', 'plane_15', null, null, null, null, 293.0), 
('p37', 'Tracy', 'Hale', 'plane_15', null, null, null, null, 552.0), 
('p38', 'Albert', 'Simmons', 'port_1', null, null, null, null, 812.0), 
('p39', 'Karen', 'Terry', 'port_9', null, null, null, null, 541.0),
('p4', 'Kendra', 'Jacobs', 'plane_4', '776-21-8098', 24.0, 'American', 'n330ss', null), 
('p40', 'Glen', 'Kelley', 'plane_4', null, null, null, null, 441.0), 
('p41', 'Brooke', 'Little', 'port_4', null, null, null, null, 875.0), 
('p42', 'Daryl', 'Nguyen', 'port_3', null, null, null, null, 691.0),
('p43', 'Judy', 'Willis', 'port_1', null, null, null, null, 572.0), 
('p44', 'Marco', 'Klein', 'port_2', null, null, null, null, 572.0), 
('p45', 'Angelica', 'Hampton', 'port_5', null, null, null, null, 663.0), 
('p5', 'Jeff', 'Burton', 'plane_4', '933-93-2165', 27.0, 'American', 'n330ss', null), 
('p6', 'Randal', 'Parks', 'plane_7', '707-84-4555', 38.0, 'United', 'n517ly', null), 
('p7', 'Sonya', 'Owens', 'plane_7', '450-25-5617', 13.0, 'United', 'n517ly', null), 
('p8', 'Bennie', 'Palmer', 'plane_8', '701-38-2179', 12.0, 'United', 'n620la', null), 
('p9', 'Marlene', 'Warner', 'plane_8', '936-44-6941', 13.0, 'United', 'n620la', null);

INSERT INTO tickets VALUES
('tkt_dl_1', 450, 'DL_1174', 'p24', 'JFK'),
('tkt_dl_2', 225, 'DL_1174', 'p25', 'JFK'),
('tkt_am_3', 250, 'AM_1523', 'p26', 'LAX'),
('tkt_un_4', 175, 'UN_1899', 'p27', 'DCA'),
('tkt_un_5', 225, 'UN_523', 'p28', 'ATL'),	
('tkt_un_6', 100, 'UN_523', 'p29', 'ORD'),		
('tkt_sw_7', 400, 'SW_1776', 'p30', 'ORD'),		
('tkt_sw_8', 175, 'SW_1776', 'p31', 'ORD'),	
('tkt_sw_9', 125, 'SW_610', 'p32', 'HOU'),		
('tkt_sw_10', 425, 'SW_610', 'p33', 'HOU'),
('tkt_dl_11', 500, 'DL_1243', 'p34', 'LAX'),
('tkt_dl_12', 250, 'DL_1243', 'p35', 'LAX'),
('tkt_sp_13', 225, 'SP_1880', 'p36', 'ATL'),
('tkt_sp_14', 150, 'SP_1880', 'p37', 'DCA'),
('tkt_un_15', 150, 'UN_523', 'p38', 'ORD'),
('tkt_sp_16', 475, 'SP_1880', 'p39', 'ATL'),	
('tkt_am_17', 375, 'AM_1523', 'p40', 'ORD'),
('tkt_am_18', 275, 'AM_1523', 'p41', 'LAX'); 

INSERT INTO pilotLicenses values
('p1', 'jet'),
('p10','jet'),
('p11', 'jet'),
('p11', 'prop'),
('p12', 'prop'),
('p13', 'jet'),
('p14', 'jet'),
('p15', 'jet'),
('p15', 'prop'),
('p15', 'testing'),
('p16', 'jet'),
('p17', 'jet'),
('p17', 'prop'),
('p18', 'jet'),
('p19', 'jet'),
('p2', 'jet'),
('p2', 'prop'),
('p20', 'jet'),
('p21', 'jet'),
('p21', 'prop'),
('p22', 'jet'),
('p23', 'jet'),
('p24', 'jet'),
('p24', 'prop'),
('p24', 'testing'),
('p25', 'jet'),
('p26', 'jet'),
('p3', 'jet'),
('p4', 'jet'),
('p4', 'prop'),
('p5', 'jet'),
('p6', 'jet'),
('p6', 'prop'),
('p7', 'jet'),
('p8', 'prop'),
('p9', 'jet'),
('p9', 'prop'),
('p9', 'testing');

INSERT INTO ticketSeat VALUES
('tkt_dl_1', '1C'),
('tkt_dl_1',  '2F'),
('tkt_am_3',  '3B'),
('tkt_un_4',  '2B'),
('tkt_un_5',  '1A'),
('tkt_un_6',  '3B'),
('tkt_sw_7', '3C'),
('tkt_sw_8', '3E'),
('tkt_sw_9', '1C'),
('tkt_sw_10', '1D'),
('tkt_dl_11', '1E'),
('tkt_dl_11', '1B'),
('tkt_dl_11', '2F'),
('tkt_dl_12', '2A'),
('tkt_sp_13', '1A'),
('tkt_sp_14', '2B'),
('tkt_un_15', '1B'),
('tkt_sp_16', '2C'),
('tkt_sp_16', '2E'),
('tkt_am_17', '2B'),
('tkt_am_18', '2A');

INSERT INTO routecontains VALUES 
('circle_east_coast', 'leg_4', 1),
('circle_east_coast', 'leg_20', 2),
('circle_east_coast', 'leg_7', 3),
('circle_west_coast', 'leg_18', 1),
('circle_west_coast', 'leg_10', 2),
('circle_west_coast', 'leg_22', 3),
('eastbound_north_milk_run', 'leg_24', 1),
('eastbound_north_milk_run', 'leg_20', 2),
('eastbound_north_milk_run', 'leg_8', 3),
('eastbound_north_nonstop', 'leg_23', 1),
('eastbound_south_milk_run', 'leg_18', 1),
('eastbound_south_milk_run', 'leg_9', 2),
('eastbound_south_milk_run', 'leg_1', 3),
('hub_xchg_southeast', 'leg_25', 1),
('hub_xchg_southeast', 'leg_4', 2),
('hub_xchg_southwest', 'leg_22', 1),
('hub_xchg_southwest', 'leg_26', 2),
('local_texas', 'leg_12', 1),
('local_texas', 'leg_6', 2),
('northbound_east_coast', 'leg_3', 1),
('northbound_west_coast', 'leg_19', 1),
('southbound_midwest', 'leg_21', 1),
('westbound_north_milk_run', 'leg_16', 1),
('westbound_north_milk_run', 'leg_22', 2),
('westbound_north_milk_run', 'leg_19', 3),
('westbound_north_nonstop', 'leg_17', 1),
('westbound_south_nonstop', 'leg_27', 1);



