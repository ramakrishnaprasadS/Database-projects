-- Active: 1671708805339@@127.0.0.1@3308@flightsdb
use flightsdb;
show tables;

ALTER TABLE COUNTRY ADD CONSTRAINT `PK_Country_code` PRIMARY KEY(country_code);

ALTER TABLE Address ADD CONSTRAINT `PK_Address_id` PRIMARY KEY(address_id);

ALTER TABLE Passenger ADD CONSTRAINT `PK_Passenger` PRIMARY KEY(passenger_id);
ALTER TABLE Passenger ADD CONSTRAINT `FK_Passenger_Address_id` FOREIGN KEY(address_id) REFERENCES Address(Address_id);


ALTER TABLE Airport ADD CONSTRAINT `PK_Airport_code` PRIMARY KEY(airport_code);
ALTER TABLE Airport ADD CONSTRAINT `FK_Airport_country_code` FOREIGN KEY(country_code) REFERENCES country(country_code);


ALTER TABLE Routes ADD CONSTRAINT `PK_Routes_id` PRIMARY KEY(route_id);
ALTER TABLE Routes ADD CONSTRAINT `FK_Routes_Airport_origin` FOREIGN KEY(origin_airport_code) REFERENCES Airport(airport_code) ;
ALTER TABLE Routes ADD CONSTRAINT `FK_Routes_Airport_dest` FOREIGN KEY(dest_airport_code) REFERENCES Airport(airport_code) ;

ALTER TABLE Schedule ADD CONSTRAINT `PK_Schedule_id` PRIMARY KEY(schedule_id);

ALTER TABLE Airlines ADD CONSTRAINT `PK_Airlines_id` PRIMARY KEY(airlines_id);

ALTER TABLE Airplane ADD CONSTRAINT `PK_Airplane_id` PRIMARY KEY(airplane_id);
ALTER TABLE Airplane ADD CONSTRAINT `FK_Airplane_Airlines` FOREIGN KEY(airlines_id) REFERENCES Airlines(airlines_id);

ALTER TABLE AirplaneSeat ADD CONSTRAINT `PK_AirplaneSeatgrp` PRIMARY KEY(airplaneseat_grp);
ALTER TABLE AirplaneSeat ADD CONSTRAINT `FK_AirplaneSeat_Airplane_id` FOREIGN KEY(airplane_id) REFERENCES Airplane(airplane_id);

ALTER TABLE Flight ADD CONSTRAINT `PK_Flight_id` PRIMARY KEY(flight_id);
ALTER TABLE Flight ADD CONSTRAINT `FK_Flight_Airplane_id` FOREIGN KEY(airplane_id) REFERENCES Airplane(airplane_id);
ALTER TABLE Flight ADD CONSTRAINT `FK_Flight_Schedule_id` FOREIGN KEY(schedule_id) REFERENCES Schedule(schedule_id);
ALTER TABLE Flight ADD CONSTRAINT `FK_Flight_Route_id` FOREIGN KEY(Route_id) REFERENCES Routes(route_id);

ALTER TABLE Booking ADD CONSTRAINT `PK_Booking` PRIMARY KEY(booking_id);    
ALTER TABLE Booking ADD CONSTRAINT `FK_Booking_Flight_id` FOREIGN KEY(flight_id) REFERENCES Flight(flight_id);
ALTER TABLE Booking ADD CONSTRAINT `FK_Booking_AirplaneSeat_grp` FOREIGN KEY(airplaneseat_grp) REFERENCES AirplaneSeat(airplaneseat_grp);
ALTER TABLE Booking ADD CONSTRAINT `FK_Booking_Passenger_id` FOREIGN KEY(passenger_id) REFERENCES Passenger(passenger_id);
