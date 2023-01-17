CREATE DATABASE IF NOT EXISTS `Airlinesdb_new` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
use Airlinesdb_new;
show tables;


CREATE TABLE AIRPORT(
AIRPORT_CODE VARCHAR(25),
AIRPORT_NAME VARCHAR(100) NOT NULL,
LOCATION VARCHAR(50) NOT NULL,
CITY VARCHAR(50) NOT NULL,
AP_STATE VARCHAR(50) NOT NULL,
COUNTRY VARCHAR(50) NOT NULL,
ZIP INT NOT NULL
);



CREATE TABLE AIRLINE_COMPANY(
AIRLINES_ID VARCHAR(50) ,
AIRLINES_NAME VARCHAR(100) NOT NULL
);



CREATE TABLE AIRPLANE(
AIRPLANE_NO VARCHAR(25) ,
SEATING_CAPACITY INT NOT NULL,
AIRLINES_ID VARCHAR(50) NOT NULL
);



CREATE TABLE PLANE_PORT_ACCESS(
AIRPORT VARCHAR(25) NOT NULL,
AIRPLANE VARCHAR(25) NOT NULL
);



CREATE TABLE SEAT(
AIRPLANE_NO VARCHAR(25) NOT NULL,
SEAT_NO VARCHAR(5) NOT NULL,
AVAILABILITY VARCHAR(10) DEFAULT 'TRUE',
LOCATION VARCHAR(25) NOT NULL,
SEAT_CLASS VARCHAR(25) NOT NULL
);



CREATE TABLE END_USER (
EMAIL VARCHAR(25) ,
FNAME VARCHAR(25) NOT NULL,
LNAME VARCHAR(25) NOT NULL,
PHONE BIGINT,
TYPE_OF_USER VARCHAR(25) NOT NULL
);




CREATE TABLE FLIGHT_TRIP(
FLIGHT_TRIP_ID VARCHAR(15) ,
NO_OF_TRAVELLERS INT NOT NULL,
ARRIVAL_AIRPORT VARCHAR(25) NOT NULL,
ARRIVAL_TIME DATE NOT NULL,
DEPART_AIRPORT VARCHAR(25) NOT NULL,
DEPART_TIME DATE NOT NULL,
USER_EMAIL VARCHAR(25) NOT NULL
);



CREATE TABLE FARE(
FLIGHT_TRIP_ID VARCHAR(15) ,
FINAL_AMOUNT DECIMAL(9,2) NOT NULL,
AMOUNT DECIMAL(9,2) NOT NULL,
CURRENCY VARCHAR(5) NOT NULL,
DISCOUNT DECIMAL(4,2) NOT NULL,
TAX DECIMAL(5,2) NOT NULL
);


CREATE TABLE TRAVELLER(
ID BIGINT,
PHONE BIGINT,
FNAME VARCHAR(25) NOT NULL,
LNAME VARCHAR(25) NOT NULL
);



CREATE TABLE TRAVELLER_TICKET(
FLIGHT VARCHAR(15) NOT NULL,
TICKET_ID VARCHAR(15),
SEAT_NO VARCHAR(5),
AIRPLANE_NO VARCHAR(25),
TRAVELLER_ID BIGINT
);



CREATE TABLE Airplane_Routes_Schedule(
ARS_ID VARCHAR(15) ,
DISTANCE DECIMAL(7,2) NOT NULL,
BASE_FARE DECIMAL(9,2) NOT NULL,
AIRPLANE_NO VARCHAR(25) NOT NULL,
ARRIVAL_AIRPORT VARCHAR(25) NOT NULL,
ARRIVAL_TIME DATE NOT NULL,
DEPART_AIRPORT VARCHAR(25) NOT NULL,
DEPART_TIME DATE NOT NULL
);



CREATE TABLE Airplane_Flight_Trips(
ARS_ID VARCHAR(25) NOT NULL,
FLIGHT_TRIP VARCHAR(15) NOT NULL
);







