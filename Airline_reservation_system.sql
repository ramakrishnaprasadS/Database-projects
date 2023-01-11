-- Active: 1671708805339@@127.0.0.1@3308@hr_db


show databases;



CREATE DATABASE IF NOT EXISTS `Airlines_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

use Airlines_db;

CREATE TABLE country
(
    country_code CHAR(3),
    country_name VARCHAR(20),
);

CREATE TABLE Passenger
(
    passenger_id INT,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    gender VARCHAR(5),
    phone VARCHAR(20),
    email VARCHAR(20),
    passport VARCHAR(20),
    country_code CHAR(3)

);

ALTER TABLE Passenger ADD CONSTRAINT `PK_Passenger` PRIMARY KEY(passenger_id);
ALTER TABLE Passenger ADD CONSTRAINT `FK_Passenger_country` FOREIGN KEY(country_code) REFERENCES country(country_code) ON DELETE SET NULL;

CREATE TABLE Airport
(
    airport_code CHAR(3),
    airport_name VARCHAR(20),
    city VARCHAR(20),
    country_code CHAR(3)
);

ALTER TABLE Airport ADD CONSTRAINT `PK_Airport` PRIMARY KEY(airport_code);
ALTER TABLE Airport ADD CONSTRAINT `FK_Airport_country` FOREIGN KEY(country_code) REFERENCES country(country_code) ON DELETE SET NULL;


CREATE TABLE Schedule
(
    schedule_id INT(5),
    origin_airport_code CHAR(3),
    dest_airport_code CHAR(3),
    departure_time_gmt TIMESTAMP,
    arrival_time_gmt TIMESTAMP

);

ALTER TABLE Schedule ADD CONSTRAINT `PK_Schedule` PRIMARY KEY(schedule_id);
ALTER TABLE Schedule ADD CONSTRAINT `FK_Schedule_Airport` FOREIGN KEY(origin_airport_code) REFERENCES Airport(airport_code) ON DELETE SET NULL;
ALTER TABLE Schedule ADD CONSTRAINT `FK_Schedule_Airport` FOREIGN KEY(dest_airport_code) REFERENCES Airport(airport_code) ON DELETE SET NULL;


CREATE TABLE Flight
(
    flight_id INT(5),
    schedule_id INT(5),
    flight_status CHAR(5)
);
ALTER TABLE Flight ADD CONSTRAINT `PK_Flight` PRIMARY KEY(flight_id);
ALTER TABLE Flight ADD CONSTRAINT `FK_Flight_Schedule` FOREIGN KEY(schedule_id) REFERENCES Schedule(schedule_id) ON DELETE SET NULL;


CREATE TABLE Aircraft
(
    flight_id INT(5),
    aircraft_id INT(5),
    aircraft_name VARCHAR(20)

);

ALTER TABLE Aircraft ADD CONSTRAINT `PK_Aircraft` PRIMARY KEY(aircraft_id);
ALTER TABLE Aircraft ADD CONSTRAINT `FK_Aircraft_Flight` FOREIGN KEY(Flight_id) REFERENCES Flight(flight_id) ON DELETE SET NULL;


CREATE TABLE AircraftSeat
(
    aircraft_id INT(5),
    seat_id INT(5),
    travel_classid INT(3)
);

ALTER TABLE AircraftSeat ADD CONSTRAINT `PK_AircraftSeat` PRIMARY KEY(seat_id);
ALTER TABLE AircraftSeat ADD CONSTRAINT `FK_AircraftSeat_Aircraft` FOREIGN KEY(aircraft_id) REFERENCES Aircraft(aircraft_id) ON DELETE SET NULL;

CREATE TABLE TravelClass
(
    travel_classid INT(3),
    class_name VARCHAR(10),
);

ALTER TABLE TravelClass ADD CONSTRAINT `PK_TravelClass` PRIMARY KEY(travel_classid);


CREATE TABLE FlightSeatPrice 
(
    flight_id INT(5),
    aircraft_id INT(5),
    seat_id INT(5),
    price_usd DECIMAL(5,2)
);

ALTER TABLE FlightSeatPrice ADD CONSTRAINT `PK_FlightSeatPrice` PRIMARY KEY();    ------doubt
ALTER TABLE FlightSeatPrice ADD CONSTRAINT `FK_FlightSeatPrice_Aircraft` FOREIGN KEY(aircraft_id) REFERENCES Aircraft(aircraft_id) ON DELETE SET NULL;
ALTER TABLE FlightSeatPrice ADD CONSTRAINT `FK_FlightSeatPrice_Flight` FOREIGN KEY(flight_id) REFERENCES Flight(flight_id) ON DELETE SET NULL;

ALTER TABLE FlightSeatPrice ADD CONSTRAINT `FK_FlightSeatPrice_AircraftSeat` FOREIGN KEY(seat_id) REFERENCES AircraftSeat(seat_id) ON DELETE SET NULL;



CREATE TABLE Booking
(
    booking_id INT(5)
    client_id INT(5),
    flight_id INT(5),
    aircraft_id INT(5),
    seta_id INT(5)
);

ALTER TABLE Booking ADD CONSTRAINT `PK_Booking` PRIMARY KEY(booking_id);    
ALTER TABLE Booking ADD CONSTRAINT `FK_Booking_Aircraft` FOREIGN KEY(aircraft_id) REFERENCES Aircraft(aircraft_id) ON DELETE SET NULL;
ALTER TABLE Booking ADD CONSTRAINT `FK_Booking_Flight` FOREIGN KEY(flight_id) REFERENCES Flight(flight_id) ON DELETE SET NULL;

ALTER TABLE Booking ADD CONSTRAINT `FK_Booking_AircraftSeat` FOREIGN KEY(seat_id) REFERENCES AircraftSeat(seat_id) ON DELETE SET NULL;




