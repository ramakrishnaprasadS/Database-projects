-- Active: 1671708805339@@127.0.0.1@3308@airlines_db


show databases;



CREATE DATABASE IF NOT EXISTS `Airlines_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

use Airlines_db;
show tables;
----------------------------------------------------------------------------
CREATE TABLE Country
(
    country_code CHAR(3) NOT NULL,
    country_name VARCHAR(20) NOT NULL UNIQUE
);
ALTER TABLE COUNTRY ADD CONSTRAINT `PK_Country` PRIMARY KEY(country_code);

INSERT INTO `Country` VALUES ('AS','American Samoa'),('BZL','Brazil'),('CHL','Chile'),('CYS','Cyprus'),('DMK','Denmark'),('GRC','Greece'),('IRL','Ireland'),('ITL','Italy'),('JPN','Japan'),('PTR','Palestinian Territor');
DESC country;
select * from country;
------------------------------------------------------------------

CREATE TABLE Address
(
    address_id INT(5),
    address_line1 VARCHAR(15) DEFAULT NULL,
    city VARCHAR(20) NOT NULL,
    pincode INT(7) NOT NULL,
    country_code CHAR(3) NOT NULL

);

ALTER TABLE Address ADD CONSTRAINT `PK_Addressid` PRIMARY KEY(address_id);
ALTER TABLE Address ADD CONSTRAINT `FK_Address_country` FOREIGN KEY(country_code) REFERENCES country(country_code);

DESC Address;
select * from Address;


---------------------------------------------------------------------

CREATE TABLE Passenger
(
    passenger_id INT(5),
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    phone VARCHAR(20) DEFAULT NULL,
    email VARCHAR(20) NOT NULL UNIQUE,
    passport_id VARCHAR(20) DEFAULT NULL,
    address_id INT(5)

);

ALTER TABLE Passenger ADD CONSTRAINT `PK_Passenger` PRIMARY KEY(passenger_id);
ALTER TABLE Passenger ADD CONSTRAINT `FK_Passenger_Address` FOREIGN KEY(address_id) REFERENCES Address(Address_id);
DESC passenger;
select * from Passenger;

---------------------------------------------------------------------------

CREATE TABLE Airport
(
    airport_code CHAR(3),
    airport_name VARCHAR(20) NOT NULL UNIQUE,
    city VARCHAR(20) NOT NULL,
    country_code CHAR(3)
);

ALTER TABLE Airport ADD CONSTRAINT `PK_Airport` PRIMARY KEY(airport_code);
ALTER TABLE Airport ADD CONSTRAINT `FK_Airport_country` FOREIGN KEY(country_code) REFERENCES country(country_code);

desc Airport;
select * from Airport;
----------------------------------------------------------------

CREATE TABLE Airlines
(
    airlines_id char(5),
    airlines_name VARCHAR(25) NOT NULL
);

ALTER TABLE Airlines ADD CONSTRAINT `PK_Airlines_id` PRIMARY KEY(airlines_id);

----------------------------------------------------------------

CREATE TABLE Routes
(
    route_id CHAR(6),
    origin_airport_code CHAR(3) NOT NULL,
    dest_airport_code CHAR(3) NOT NULL,
    ditance_km   BIGINT UNSIGNED NOT NULL
);
ALTER TABLE Routes ADD CONSTRAINT `PK_Routes` PRIMARY KEY(route_id);
ALTER TABLE Routes ADD CONSTRAINT `FK_Routes_Airport_origin` FOREIGN KEY(origin_airport_code) REFERENCES Airport(airport_code) ;
ALTER TABLE Routes ADD CONSTRAINT `FK_Routes_Airport_dest` FOREIGN KEY(dest_airport_code) REFERENCES Airport(airport_code) ;

show create table routes;


----------------------------------------------
CREATE TABLE Schedule
(
    schedule_id INT(5),
    onboarding_time_gmt TIMESTAMP ,
    offboarding_time_gmt TIMESTAMP
);

ALTER TABLE Schedule ADD CONSTRAINT `PK_Schedule_id` PRIMARY KEY(schedule_id);


----------------------------------------------------------------

CREATE TABLE Airplane
(
    airplane_id CHAR(10),
    airlines_id CHAR(5)
);

ALTER TABLE Airplane ADD CONSTRAINT `PK_Airplane_id` PRIMARY KEY(airplane_id);
ALTER TABLE Airplane ADD CONSTRAINT `FK_Airplane_Airlines` FOREIGN KEY(airlines_id) REFERENCES Airlines(airlines_id);

-----------------------------------------------------------

CREATE TABLE Flight
(
    flight_id INT(10) UNSIGNED,
    airplane_id CHAR(10),
    route_id CHAR(6),
    schedule_id INT(5)
);
ALTER TABLE Flight ADD CONSTRAINT `PK_Flight_id` PRIMARY KEY(flight_id);
ALTER TABLE Flight ADD CONSTRAINT `FK_Flight_Airplane_id` FOREIGN KEY(airplane_id) REFERENCES Airplane(airplane_id);
ALTER TABLE Flight ADD CONSTRAINT `FK_Flight_Schedule_id` FOREIGN KEY(schedule_id) REFERENCES Schedule(schedule_id);
ALTER TABLE Flight ADD CONSTRAINT `FK_Flight_Route_id` FOREIGN KEY(Route_id) REFERENCES Route(route_id);



--------------------------------------------------------


CREATE TABLE AirplaneSeat
(   airplaneseat_grp CHAR(10)
    airplane_id CHAR(10),
    class enum("FC","BC","EC"),
    total_seats INT(3) UNSIGNED NOT NULL,
    seat_price INT(5) UNSIGNED
);

ALTER TABLE AirplaneSeat ADD CONSTRAINT `PK_AirplaneSeatgrp` PRIMARY KEY(airplaneseat_grp);
ALTER TABLE AirplaneSeat ADD CONSTRAINT `FK_AirplaneSeat_Airplane_id` FOREIGN KEY(airplane_id) REFERENCES Airplane(airplane_id);

Alter TABLE aircraftseat DROP column travel_classid;
------------------------------------------------------------------------------------
CREATE TABLE TravelClass
(
    travel_classid INT(3),
    class_name VARCHAR(10) NOT NULL
);

ALTER TABLE TravelClass ADD CONSTRAINT `PK_TravelClass` PRIMARY KEY(travel_classid);

------------------------------------------------------------
CREATE TABLE FlightSeatPrice 
(
    flight_seat_id INT(5),
    flight_id INT(5),
    aircraft_seat_id INT(5),
    price_usd DECIMAL(5,2) DEFAULT 0
);

ALTER TABLE FlightSeatPrice ADD CONSTRAINT `PK_FlightSeatPrice` PRIMARY KEY(flight_seat_id);    
ALTER TABLE FlightSeatPrice ADD CONSTRAINT `FK_FlightSeatPrice_Flight` FOREIGN KEY(flight_id) REFERENCES Flight(flight_id);
ALTER TABLE FlightSeatPrice ADD CONSTRAINT `FK_FlightSeatPrice_AircraftSeat` FOREIGN KEY(aircraft_seat_id) REFERENCES AircraftSeat(aircraft_seat_id);

------------------------------------------------------------------------

CREATE TABLE Booking
(
    booking_id INT(10),
    flight_id INT(10) UNSIGNED,
    airplaneseat_grp CHAR(10)
    passenger_id INT(5),
    total_fare INT(6) UNSIGNED DEFAULT 0
);

ALTER TABLE Booking ADD CONSTRAINT `PK_Booking` PRIMARY KEY(booking_id);    
ALTER TABLE Booking ADD CONSTRAINT `FK_Booking_Flight_id` FOREIGN KEY(flight_id) REFERENCES Flight(flight_id);
ALTER TABLE Booking ADD CONSTRAINT `FK_Booking_AirplaneSeat_grp` FOREIGN KEY(airplaneseat_grp) REFERENCES AirplaneSeat(airplaneseat_grp);
ALTER TABLE Booking ADD CONSTRAINT `FK_Booking_Passenger_id` FOREIGN KEY(passenger_id) REFERENCES Passenger(passenger_id);




