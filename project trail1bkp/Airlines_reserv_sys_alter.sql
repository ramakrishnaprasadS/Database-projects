-- Active: 1671708805339@@127.0.0.1@3308@airlinesdb_new


ALTER TABLE AIRPORT ADD CONSTRAINT AIRPORT_PK PRIMARY KEY (AIRPORT_CODE);



ALTER TABLE AIRLINES ADD CONSTRAINT AIRLINES_PK PRIMARY KEY (AIRLINES_ID);



ALTER TABLE AIRPLANE ADD CONSTRAINT AIRPLANE_PK PRIMARY KEY (AIRPLANE_NO);
ALTER TABLE AIRPLANE ADD CONSTRAINT PLANE_COMPANY_FK FOREIGN KEY (AIRLINES_ID) REFERENCES AIRLINES(AIRLINES_ID);



ALTER TABLE PLANE_PORT_ACCESS ADD CONSTRAINT ACCESS_PK PRIMARY KEY (AIRPORT,AIRPLANE);
ALTER TABLE PLANE_PORT_ACCESS ADD CONSTRAINT ACCESS_PORT_FK FOREIGN KEY (AIRPORT_CODE) REFERENCES AIRPORT(AIRPORT_CODE) ON DELETE CASCADE;
ALTER TABLE PLANE_PORT_ACCESS ADD CONSTRAINT ACCESS_PLANE_FK FOREIGN KEY (AIRPLANE_NO) REFERENCES AIRPLANE(AIRPLANE_NO) ON DELETE CASCADE;


ALTER TABLE SEAT ADD CONSTRAINT SEAT_PK PRIMARY KEY (AIRPLANE_NO,SEAT_NO);
ALTER TABLE SEAT ADD CONSTRAINT SEAT_PLANE_FK FOREIGN KEY (AIRPLANE_NO) REFERENCES AIRPLANE(AIRPLANE_NO) ON DELETE CASCADE;


ALTER TABLE END_USER ADD CONSTRAINT USER_PK PRIMARY KEY (EMAIL);



ALTER TABLE FLIGHT_TRIP ADD CONSTRAINT FLIGHT_TRIP_PK PRIMARY KEY(FLIGHT_TRIP_ID);
ALTER TABLE FLIGHT_TRIP ADD CONSTRAINT FLIGHT_TRIP_USER_FK FOREIGN KEY(EMAIL) REFERENCES END_USER(EMAIL);



ALTER TABLE FARE ADD CONSTRAINT FARE_PK PRIMARY KEY (FLIGHT_TRIP_ID);
ALTER TABLE FARE ADD CONSTRAINT FARE_FLT_TRIP_FK FOREIGN KEY(FLIGHT_TRIP_ID) REFERENCES FLIGHT_TRIP(FLIGHT_TRIP_ID) ON DELETE CASCADE;



ALTER TABLE TRAVELLER ADD CONSTRAINT TRAVELLER_PK PRIMARY KEY(ID);



ALTER TABLE TRAVELLER_TICKET ADD CONSTRAINT TRAVELLER_PKK PRIMARY KEY(FLIGHT,SEAT_NO,AIRPLANE_NO);
ALTER TABLE TRAVELLER_TICKET ADD CONSTRAINT TRVLR_FLT_TRIP_FK FOREIGN KEY (FLIGHT_TRIP_ID) REFERENCES FLIGHT_TRIP(FLIGHT_TRIP_ID) ON DELETE CASCADE;
ALTER TABLE TRAVELLER_TICKET ADD CONSTRAINT TRVLR_SEAT_FK FOREIGN KEY(AIRPLANE_NO,SEAT_NO) REFERENCES SEAT(AIRPLANE_NO,SEAT_NO);
ALTER TABLE TRAVELLER_TICKET ADD CONSTRAINT TRVLR_ID_FK FOREIGN KEY(ID) REFERENCES TRAVELLER(ID);


ALTER TABLE Airplane_Routes_Schedule ADD CONSTRAINT ARS_PK PRIMARY KEY (ARS_ID);
ALTER TABLE Airplane_Routes_Schedule ADD CONSTRAINT ARS_APLNE_FK FOREIGN KEY (AIRPLANE_NO) REFERENCES AIRPLANE(AIRPLANE_NO);
ALTER TABLE Airplane_Routes_Schedule ADD CONSTRAINT ARS_ARVL_ARPRT_FK FOREIGN KEY(ARRIVAL_AIRPORT) REFERENCES AIRPORT(AIRPORT_CODE);
ALTER TABLE Airplane_Routes_Schedule ADD CONSTRAINT ARS_DRPT_ARPRT_FK FOREIGN KEY(DEPART_AIRPORT) REFERENCES AIRPORT(AIRPORT_CODE);



ALTER TABLE Airplane_Flight_Trips ADD CONSTRAINT ARS_AFT_FT_PK PRIMARY KEY(ARS_ID,FLIGHT_TRIP);
ALTER TABLE Airplane_Flight_Trips ADD CONSTRAINT ARS_AFT_FK FOREIGN KEY (ARS_ID) REFERENCES Airplane_Routes_Schedule(ARS_ID);
ALTER TABLE Airplane_Flight_Trips ADD CONSTRAINT FT_AFT_FK FOREIGN KEY(FLIGHT_TRIP_ID) REFERENCES FLIGHT_TRIP(FLIGHT_TRIP_ID) ON DELETE CASCADE;
