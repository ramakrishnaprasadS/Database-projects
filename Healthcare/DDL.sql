-- Active: 1671786369069@@127.0.0.1@3308@healthcare

use HealthCare;


CREATE TABLE `address` (
  `addressID` int NOT NULL,
  `address1` varchar(200) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `zip` int DEFAULT NULL,
  PRIMARY KEY (`addressID`)
) ;

 CREATE TABLE `claim` (
  `claimID` bigint NOT NULL,
  `balance` bigint NOT NULL,
  `uin` varchar(22) NOT NULL,
  PRIMARY KEY (`claimID`),
  KEY `FK_Insurance_Claim` (`uin`),
  CONSTRAINT `FK_Insurance_Claim` FOREIGN KEY (`uin`) REFERENCES `insuranceplan` (`uin`)
);

 CREATE TABLE `contain` (
  `prescriptionID` bigint NOT NULL,
  `medicineID` int NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`prescriptionID`,`medicineID`),
  KEY `FK_medicine_contain` (`medicineID`),
  CONSTRAINT `FK_medicine_contain` FOREIGN KEY (`medicineID`) REFERENCES `medicine` (`medicineID`),
  CONSTRAINT `FK_prescription_contain` FOREIGN KEY (`prescriptionID`) REFERENCES `prescription` (`prescriptionID`)
);

 CREATE TABLE `disease` (
  `diseaseID` int NOT NULL,
  `diseaseName` varchar(100) NOT NULL,
  `description` varchar(1000) NOT NULL,
  PRIMARY KEY (`diseaseID`)
);

 CREATE TABLE `insurancecompany` (
  `companyID` int NOT NULL,
  `companyName` varchar(100) DEFAULT NULL,
  `addressID` int DEFAULT NULL,
  PRIMARY KEY (`companyID`),
  KEY `FK_address_InsCompany` (`addressID`),
  CONSTRAINT `FK_address_InsCompany` FOREIGN KEY (`addressID`) REFERENCES `address` (`addressID`)
);

CREATE TABLE `insuranceplan` (
  `uin` varchar(25) NOT NULL,
  `planName` varchar(100) DEFAULT NULL,
  `companyID` int DEFAULT NULL,
  PRIMARY KEY (`uin`),
  KEY `FK_InsCompany_InsPlan` (`companyID`),
  CONSTRAINT `FK_InsCompany_InsPlan` FOREIGN KEY (`companyID`) REFERENCES `insurancecompany` (`companyID`)
);

CREATE TABLE `keep` (
  `pharmacyID` int NOT NULL,
  `medicineID` int NOT NULL,
  `quantity` int DEFAULT NULL,
  `discount` int DEFAULT NULL,
  PRIMARY KEY (`pharmacyID`,`medicineID`),
  KEY `FK_medicine_keep` (`medicineID`),
  CONSTRAINT `FK_medicine_keep` FOREIGN KEY (`medicineID`) REFERENCES `medicine` (`medicineID`),
  CONSTRAINT `FK_pharmacy_keep` FOREIGN KEY (`pharmacyID`) REFERENCES `pharmacy` (`pharmacyID`)
);

 CREATE TABLE `medicine` (
  `medicineID` int NOT NULL,
  `companyName` varchar(101) DEFAULT NULL,
  `productName` varchar(174) DEFAULT NULL,
  `description` varchar(161) DEFAULT NULL,
  `substanceName` varchar(255) DEFAULT NULL,
  `productType` int DEFAULT NULL,
  `taxCriteria` varchar(3) DEFAULT NULL,
  `hospitalExclusive` varchar(1) DEFAULT NULL,
  `governmentDiscount` varchar(1) DEFAULT NULL,
  `taxImunity` varchar(1) DEFAULT NULL,
  `maxPrice` decimal(9,2) DEFAULT NULL,
  PRIMARY KEY (`medicineID`)
);

 CREATE TABLE `patient` (
  `patientID` int NOT NULL,
  `ssn` int DEFAULT NULL,
  `dob` date DEFAULT NULL,
  PRIMARY KEY (`patientID`),
  CONSTRAINT `FK_person_patient` FOREIGN KEY (`patientID`) REFERENCES `person` (`personID`)
);

CREATE TABLE `person` (
  `personID` int NOT NULL,
  `personName` varchar(22) DEFAULT NULL,
  `phoneNumber` bigint DEFAULT NULL,
  `gender` varchar(6) DEFAULT NULL,
  `addressID` int DEFAULT NULL,
  PRIMARY KEY (`personID`),
  KEY `FK_address_person` (`addressID`),
  CONSTRAINT `FK_address_person` FOREIGN KEY (`addressID`) REFERENCES `address` (`addressID`)
);

 CREATE TABLE `pharmacy` (
  `pharmacyID` int NOT NULL,
  `pharmacyName` varchar(33) NOT NULL,
  `phone` bigint NOT NULL,
  `addressID` int NOT NULL,
  PRIMARY KEY (`pharmacyID`),
  KEY `FK_address_pharmacy` (`addressID`),
  CONSTRAINT `FK_address_pharmacy` FOREIGN KEY (`addressID`) REFERENCES `address` (`addressID`)
);

CREATE TABLE `prescription` (
  `prescriptionID` bigint NOT NULL,
  `pharmacyID` int DEFAULT NULL,
  `treatmentID` int DEFAULT NULL,
  PRIMARY KEY (`prescriptionID`),
  KEY `FK_pharmacy_prescription` (`pharmacyID`),
  KEY `FK_treatment_prescription` (`treatmentID`),
  CONSTRAINT `FK_pharmacy_prescription` FOREIGN KEY (`pharmacyID`) REFERENCES `pharmacy` (`pharmacyID`),
  CONSTRAINT `FK_treatment_prescription` FOREIGN KEY (`treatmentID`) REFERENCES `treatment` (`treatmentID`)
);

 CREATE TABLE `treatment` (
  `treatmentID` int NOT NULL,
  `date` date DEFAULT NULL,
  `patientID` int DEFAULT NULL,
  `diseaseID` int DEFAULT NULL,
  `claimID` bigint DEFAULT NULL,
  PRIMARY KEY (`treatmentID`),
  KEY `FK_patient_treatment` (`patientID`),
  KEY `FK_disease_treatment` (`diseaseID`),
  KEY `FK_claim_treatment` (`claimID`),
  CONSTRAINT `FK_claim_treatment` FOREIGN KEY (`claimID`) REFERENCES `claim` (`claimID`),
  CONSTRAINT `FK_disease_treatment` FOREIGN KEY (`diseaseID`) REFERENCES `disease` (`diseaseID`),
  CONSTRAINT `FK_patient_treatment` FOREIGN KEY (`patientID`) REFERENCES `patient` (`patientID`)
);



 CREATE TABLE `keep_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `medicineid` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `new_places` (
  `placeid` int NOT NULL AUTO_INCREMENT,
  `placeName` varchar(65) NOT NULL,
  `placeType` enum('city','state') DEFAULT NULL,
  `timeAdded` datetime DEFAULT NULL,
  PRIMARY KEY (`placeid`)
);







