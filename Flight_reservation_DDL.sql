-- Active: 1671708805339@@127.0.0.1@3308@flightsdb

CREATE DATABASE IF NOT EXISTS `FlightsDB` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
use FlightsDB;
show tables;

CREATE TABLE Country
(
    country_code char(3) NOT NULL,
    country_name VARCHAR(25) NOT NULL UNIQUE
);

CREATE TABLE Address
(
    address_id INT(5) UNSIGNED,
    address_line1 VARCHAR(15) DEFAULT NULL,
    city VARCHAR(20) NOT NULL,
    pincode INT(7) UNSIGNED NOT NULL,
    country_code CHAR(3) NOT NULL

);

CREATE TABLE Passenger
(
    passenger_id INT(5) UNSIGNED,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    phone VARCHAR(20) DEFAULT NULL,
    email VARCHAR(20) NOT NULL UNIQUE,
    passport_id VARCHAR(20) DEFAULT NULL,
    address_id INT(5) UNSIGNED
);

CREATE TABLE Airport
(
    airport_code CHAR(3),
    airport_name VARCHAR(20) NOT NULL UNIQUE,
    city VARCHAR(20) NOT NULL,
    country_code CHAR(3)
);

CREATE TABLE Routes
(
    route_id CHAR(6),
    origin_airport_code CHAR(3) NOT NULL,
    dest_airport_code CHAR(3) NOT NULL,
    ditance_km   BIGINT UNSIGNED NOT NULL
);

CREATE TABLE Schedule
(
    schedule_id INT(5) UNSIGNED,
    onboarding_time_gmt TIMESTAMP ,
    offboarding_time_gmt TIMESTAMP
);

CREATE TABLE Airlines
(
    airlines_id char(5),
    airlines_name VARCHAR(25) NOT NULL
);

CREATE TABLE Airplane
(
    airplane_id CHAR(10),
    airlines_id CHAR(5)
);

CREATE TABLE AirplaneSeat
(   airplaneseat_grp CHAR(10),
    airplane_id CHAR(10),
    class enum("FC","BC","EC"),
    total_seats INT(3) UNSIGNED NOT NULL,
    seat_price INT(5) UNSIGNED
);

CREATE TABLE Flight
(
    flight_id INT(10) UNSIGNED,
    airplane_id CHAR(10),
    route_id CHAR(6),
    schedule_id INT(5) UNSIGNED
);

CREATE TABLE Booking
(
    booking_id INT(10),
    flight_id INT(10) UNSIGNED,
    airplaneseat_grp CHAR(10),
    passenger_id INT(5) UNSIGNED,
    total_fare INT(6) UNSIGNED DEFAULT 0
);





