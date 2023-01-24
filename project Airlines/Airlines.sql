-- Active: 1671708805339@@127.0.0.1@3308@ars

create database airlines;

use airlines;

CREATE TABLE `countries` (
  `countryId` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`countryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `address` (
  `addressId` int unsigned NOT NULL AUTO_INCREMENT,
  `streetAddress` varchar(255) NOT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `postalCode` int unsigned NOT NULL,
  `countryId` varchar(10) NOT NULL,
  PRIMARY KEY (`addressId`),
  KEY `FK_country_address` (`countryId`),
  CONSTRAINT `FK_country_address` FOREIGN KEY (`countryId`) REFERENCES `countries` (`countryId`)
) ENGINE=InnoDB AUTO_INCREMENT=60001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `manufacturer` (
  `manId` int unsigned NOT NULL,
  `name` varchar(40) NOT NULL,
  PRIMARY KEY (`manId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `aircrafts` (
  `aircraftId` varchar(10) NOT NULL,
  `manId` int unsigned NOT NULL,
  PRIMARY KEY (`aircraftId`),
  KEY `FK_manu_aircrafts` (`manId`),
  CONSTRAINT `FK_manu_aircrafts` FOREIGN KEY (`manId`) REFERENCES `manufacturer` (`manId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `airport` (
  `airportId` varchar(5) NOT NULL,
  `name` varchar(200) NOT NULL,
  `city` varchar(40) DEFAULT NULL,
  `countryid` varchar(10) NOT NULL,
  PRIMARY KEY (`airportId`),
  KEY `FK_country_airport` (`countryid`),
  CONSTRAINT `FK_country_airport` FOREIGN KEY (`countryid`) REFERENCES `countries` (`countryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `baggage` (
  `baggageId` int unsigned NOT NULL AUTO_INCREMENT,
  `weightKg` varchar(20) NOT NULL,
  `fare` decimal(10,2) unsigned NOT NULL,
  PRIMARY KEY (`baggageId`)
) ENGINE=InnoDB AUTO_INCREMENT=906 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `customers` (
  `customerId` int unsigned NOT NULL AUTO_INCREMENT,
  `firstName` varchar(30) NOT NULL,
  `last_name` varchar(30) DEFAULT NULL,
  `phone` varchar(13) DEFAULT NULL,
  `email` varchar(30) NOT NULL,
  `addressId` int unsigned NOT NULL,
  PRIMARY KEY (`customerId`),
  KEY `FK_address_customers` (`addressId`),
  CONSTRAINT `FK_address_customers` FOREIGN KEY (`addressId`) REFERENCES `address` (`addressId`)
) ENGINE=InnoDB AUTO_INCREMENT=70001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `seats` (
  `seatId` varchar(10) NOT NULL,
  `aircraftId` varchar(10) NOT NULL,
  PRIMARY KEY (`seatId`,`aircraftId`),
  KEY `FK_aircrafts_seats` (`aircraftId`),
  CONSTRAINT `FK_aircrafts_seats` FOREIGN KEY (`aircraftId`) REFERENCES `aircrafts` (`aircraftId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `flightfare` (
  `flightId` varchar(20) NOT NULL,
  `seatId` varchar(10) NOT NULL,
  `fare` decimal(12,2) unsigned NOT NULL,
  `createDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `lastUpdated` datetime DEFAULT CURRENT_TIMESTAMP,
  KEY `FK_seats_flightfare` (`seatId`),
  CONSTRAINT `FK_seats_flightfare` FOREIGN KEY (`seatId`) REFERENCES `seats` (`seatId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `schedule` (
  `scheduleId` int NOT NULL,
  `originId` varchar(5) NOT NULL,
  `destinationId` varchar(5) NOT NULL,
  `travelTime` time NOT NULL,
  `travelDistance` int NOT NULL,
  PRIMARY KEY (`scheduleId`),
  KEY `FK_airport_schedule` (`originId`),
  KEY `FK_airport_schedule_dest` (`destinationId`),
  CONSTRAINT `FK_airport_schedule` FOREIGN KEY (`originId`) REFERENCES `airport` (`airportId`),
  CONSTRAINT `FK_airport_schedule_dest` FOREIGN KEY (`destinationId`) REFERENCES `airport` (`airportId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `flights` (
  `flightId` varchar(20) NOT NULL,
  `scheduleId` int NOT NULL,
  `status` tinyint unsigned NOT NULL DEFAULT '0',
  `lastUpdated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `departuretime` datetime DEFAULT NULL,
  `arrivaltime` datetime DEFAULT NULL,
  `airline` varchar(40) NOT NULL,
  `model` varchar(20) NOT NULL,
  PRIMARY KEY (`flightId`),
  KEY `FK_schedule_flights` (`scheduleId`),
  CONSTRAINT `FK_schedule_flights` FOREIGN KEY (`scheduleId`) REFERENCES `schedule` (`scheduleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `bookings` (
  `bookingId` int unsigned NOT NULL AUTO_INCREMENT,
  `customerId` int unsigned NOT NULL,
  `flightId` varchar(20) NOT NULL,
  `seatId` varchar(10) NOT NULL,
  `bookingStatus` varchar(15) NOT NULL DEFAULT 'In Process',
  `bookedTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastUpdated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `scheduleId` int NOT NULL,
  PRIMARY KEY (`bookingId`),
  KEY `FK_customers_bookings` (`customerId`),
  KEY `FK_flights_aircraft` (`flightId`),
  KEY `FK_flights_bookings` (`scheduleId`,`flightId`),
  CONSTRAINT `FK_customers_bookings` FOREIGN KEY (`customerId`) REFERENCES `customers` (`customerId`)
) ENGINE=InnoDB AUTO_INCREMENT=8720001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `foodmenu` (
  `itemId` int unsigned NOT NULL,
  `name` varchar(10) NOT NULL,
  `itemPrice` int unsigned NOT NULL,
  PRIMARY KEY (`itemId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `passengers` (
  `passengerId` int unsigned NOT NULL AUTO_INCREMENT,
  `firstName` varchar(30) NOT NULL,
  `lastName` varchar(30) DEFAULT NULL,
  `phone` varchar(13) DEFAULT NULL,
  `email` varchar(45) NOT NULL,
  `passport` varchar(10) DEFAULT NULL,
  `addressId` int unsigned NOT NULL,
  `seatId` varchar(10) NOT NULL,
  `bookingid` int unsigned NOT NULL,
  `flightId` varchar(20) NOT NULL,
  `baggageID` int unsigned NOT NULL,
  `customerId` int unsigned NOT NULL,
  `ItemId` int unsigned DEFAULT NULL,
  PRIMARY KEY (`passengerId`),
  KEY `FK_customers_passengers` (`customerId`),
  KEY `FK_bookings_passengers` (`bookingid`),
  KEY `FK_baggage_passengers` (`baggageID`),
  KEY `FK_address_passengers` (`addressId`),
  KEY `FK_foodmenu_passengers` (`ItemId`),
  KEY `FK_flights_passengers` (`flightId`),
  CONSTRAINT `FK_address_passengers` FOREIGN KEY (`addressId`) REFERENCES `address` (`addressId`),
  CONSTRAINT `FK_baggage_passengers` FOREIGN KEY (`baggageID`) REFERENCES `baggage` (`baggageId`),
  CONSTRAINT `FK_bookings_passengers` FOREIGN KEY (`bookingid`) REFERENCES `bookings` (`bookingId`),
  CONSTRAINT `FK_customers_passengers` FOREIGN KEY (`customerId`) REFERENCES `customers` (`customerId`),
  CONSTRAINT `FK_flights_passengers` FOREIGN KEY (`flightId`) REFERENCES `flights` (`flightId`),
  CONSTRAINT `FK_foodmenu_passengers` FOREIGN KEY (`ItemId`) REFERENCES `foodmenu` (`itemId`)
) ENGINE=InnoDB AUTO_INCREMENT=800001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

