-- Active: 1671708805339@@127.0.0.1@3308@airlinesdb_new



--AIRPORT




INSERT INTO AIRLINES VALUES
( 'AA' , 'American Airlines'),
( 'BA' , 'British Airways'),
( 'EX' , 'Atlantic Airlines'),
( 'JET' , 'Jet Airways'),
( 'SJ' , 'Spice Jet'),
('EA','Emirates Airline'),
('QA','Qatar Airlines'),
('SAA','Saudi Arabian Airlines'),
('AAS','AirAsia'),
('AC','Air China'),
('KFA','Kingfisher Airlines'),
('KRA','Korean Air'),
('SA','Singapore Airlines');




INSERT INTO AIRPLANE VALUES
( 'AA751' , 40, 'AA' ),
( 'AA851' , 60, 'AA' ),
( 'EX100' , 40, 'EX' ),
( 'JET785' , 60, 'JET' ),
( 'BA747' , 40, 'BA' );


INSERT INTO PLANE_PORT_ACCESS VALUES
( 'DFW','AA751' ),
( 'RDU','AA751' ),
( 'CLT','AA751' ),
( 'DFW','AA851' ),
( 'CLT','AA851' );



INSERT INTO SEAT VALUES
( 'AA751','A23','TRUE','WINDOW','ECONOMIC' ),
( 'AA751' ,'A24','TRUE','WINDOW','ECONOMIC' ),
( 'AA751' ,'A25','TRUE','WINDOW','ECONOMIC' ),
( 'AA851' ,'A23','TRUE','WINDOW','ECONOMIC' ),
( 'AA851' ,'A24','TRUE','WINDOW','ECONOMIC' );



INSERT INTO END_USER VALUES
('kunal.jagdish@gmail.com','Kunal','Arora',4694529483,'NORMAL' ),
('kxa142230@utdallas.edu','Kunal','Arora',4694529484,'NORMAL' ),
('shobhit@gmail.com','Shobhit','Agrawal',4694527474,'NORMAL' ),
('indervirsingh@gmail.com' ,'Indervir','Singh',4694528585,'NORMAL' ),
( 'bala@yahoo.com' ,'Bala','Yadav',4694529595,'AGENT' );



INSERT INTO FLIGHT_TRIP VALUES
('kunish17dec',1,'RDU',timestamp('2014/12/27 12:00:00'),'DFW',timestamp('2014/12/26 12:00:00'),'kunal.jagdish@gmail.com' ),
('kuniaa741',1,'RDU',timestamp('2014/12/27 12:00:00'),'DAL',timestamp('2014/12/26 12:00:00'),'kunal.jagdish@gmail.com' ),
('inder17dec',1,'RDU',timestamp('2014/12/27 12:00:00') ,'DFW',timestamp('2014/12/26 12:00:00'),'indervirsingh@gmail.com' ),
('shoaga17dec',1,'RDU',timestamp('2014/12/27 12:00:00'),'DFW',timestamp('2014/12/26 12:00:00'),'shobhit@gmail.com' ),
('bala17dec',1,'DFW',timestamp('2014/12/27 12:00:00'),'LAX',timestamp('2014/12/26 12:00:00'),'bala@yahoo.com' );



INSERT INTO FARE VALUES
( 'kunish17dec',176,200,'$',10,10 ),
( 'kuniaa741',176,200,'$',10,10 ),
( 'inder17dec',176,200,'$',10,10 ),
( 'shoaga17dec',176,200,'$',10,10 ),
( 'bala17dec',176,200,'$',10,10 );



INSERT INTO TRAVELLER VALUES
(10000001,4567891231,'Kunal','Arora' ),
(10000002,4567891241,'Indervir','Singh' ),
(10000003,4567891274,'Bala','Yadav' ),
(10000004,4567891278,'Shobhi','Agrawal'),
(10000005,4567891214,'Nitish','Salwan' );



INSERT TRAVELLER_TICKET VALUES
( 'kunish17dec',2,'A23','AA751',10000001 ),
( 'kuniaa741',6,'A24','AA751',10000002 ),
( 'inder17dec',3,'A25','AA751',10000003 ),
( 'shoaga17dec',4,'A23','AA851',10000004 ),
( 'bala17dec',5,'A24','AA851',10000005 );




INSERT INTO Airplane_Routes_Schedule VALUES
('AX7458',600,200,'AA751','RDU',timestamp('2014/12/27 12:00:00'),'DFW',timestamp('2014/12/26 12:00:00') ),
( 'AX7459',600,200,'AA851','RDU',timestamp('2014/12/27 12:00:00'),'DAL',timestamp('2014/12/26 12:00:00') ),
( 'AX7460',600,200,'AA751','RDU',timestamp('2014/12/27 12:00:00'),'LAX',timestamp('2014/12/26 12:00:00') ),
( 'AX7461',600,200,'AA751','RDU',timestamp('2014/12/27 12:00:00'),'CLT',timestamp('2014/12/26 12:00:00') ),
( 'AX7462',600,200,'AA751','DFW',timestamp('2014/12/27 12:00:00'),'CLT',timestamp('2014/12/26 12:00:00') );



INSERT INTO Airplane_Flight_Trips VALUES
( 'AX7458','kunish17dec' ),
( 'AX7459','kuniaa741' ),
( 'AX7458','inder17dec' ),
( 'AX7458','shoaga17dec' ),
( 'AX7460','bala17dec' );
