-- Active: 1671786369069@@127.0.0.1@3308@airlines3

use airlines3;

--A procedure to return all the flights for a given arrival and departure airport:

CREATE PROCEDURE get_flights(IN depart_airport VARCHAR(25), IN arrival_airport VARCHAR(25))
BEGIN
  SELECT FLIGHT_TRIP_ID, ARRIVAL_AIRPORT_CODE, ARRIVAL_TIME, DEPART_AIRPORT_CODE, DEPART_TIME
  FROM FLIGHT_TRIP
  WHERE DEPART_AIRPORT_CODE = depart_airport AND ARRIVAL_AIRPORT_CODE = arrival_airport;
END;


--A procedure to update the type of user in the USER table:

CREATE PROCEDURE update_user_type(IN email VARCHAR(25), IN type VARCHAR(25))
BEGIN
  UPDATE USER SET TYPE_OF_USER = type WHERE USER_EMAIL = email;
END;

--ADD_TRAVELLER: This procedure can be used to add a new traveller to the database.

CREATE PROCEDURE ADD_TRAVELLER(IN phone varchar(15), IN name varchar(50), IN country varchar(50))
BEGIN
  INSERT INTO TRAVELLER (PHONE, NAME, COUNTRY)
  VALUES (phone, name, country);
END;

--ADD_FLIGHT_TRIP: This procedure can be used to add a new flight trip to the database.

CREATE PROCEDURE ADD_FLIGHT_TRIP(IN flight_trip_id varchar(15), IN no_of_travellers integer, IN arrival_airport_code varchar(25), IN arrival_time datetime, IN depart_airport_code varchar(25), IN depart_time datetime, IN user_email varchar(25))
BEGIN
  INSERT INTO FLIGHT_TRIP (FLIGHT_TRIP_ID, NO_OF_TRAVELLERS, ARRIVAL_AIRPORT_CODE, ARRIVAL_TIME, DEPART_AIRPORT_CODE, DEPART_TIME, USER_EMAIL)
  VALUES (flight_trip_id, no_of_travellers, arrival_airport_code, arrival_time, depart_airport_code, depart_time, user_email);
END;




--ADD_ROUTE: This procedure can be used to add a new route to the database

CREATE PROCEDURE ADD_ROUTE(IN route_id varchar(15), IN distance decimal(7,2), IN base_fare decimal(9,2), IN airplane_no varchar(25), IN arrival_airport_code varchar(25), IN arrival_time date, IN depart_airport_code varchar(25), IN depart_time date)
BEGIN
  INSERT INTO ROUTES (ROUTE_ID, DISTANCE, BASE_FARE, AIRPLANE_NO, ARRIVAL_AIRPORT_CODE, ARRIVAL_TIME, DEPART_AIRPORT_CODE, DEPART_TIME)
  VALUES (route_id, distance, base_fare, airplane_no, arrival_airport_code, arrival_time, depart_airport_code, depart_time);
END;

--UPDATE_SEAT: This procedure can be used to update the availability status of a seat in the database.

CREATE PROCEDURE UPDATE_SEAT(IN airplane_no varchar(25), IN seat_no varchar(5), IN availability varchar(10))
BEGIN
  UPDATE SEAT
  SET AVAILABILITY = availability
  WHERE AIRPLANE_NO = airplane_no AND SEAT_NO = seat_no;
END;

--Add a new airport:

DELIMITER $$
CREATE PROCEDURE add_airport(IN airport_code varchar(25), IN airport_name varchar(100), IN city varchar(50), IN country varchar(50))
BEGIN
  INSERT INTO AIRPORT(AIRPORT_CODE, AIRPORT_NAME, CITY, COUNTRY)
  VALUES(airport_code, airport_name, city, country);
END $$
DELIMITER ;

--Add a new airline:

DELIMITER $$
CREATE PROCEDURE add_airline(IN airlines_id varchar(50), IN airlines_name varchar(100))
BEGIN
  INSERT INTO AIRLINES(AIRLINES_ID, AIRLINES_NAME)
  VALUES(airlines_id, airlines_name);
END $$
DELIMITER ;

--Add a new airplane:

DELIMITER $$
CREATE PROCEDURE add_airplane(IN airplane_no varchar(25), IN seating_capacity integer, IN airlines_id varchar(50))
BEGIN
  INSERT INTO AIRPLANE(AIRPLANE_NO, SEATING_CAPACITY, AIRLINES_ID)
  VALUES(airplane_no, seating_capacity, airlines_id);
END $$
DELIMITER ;













