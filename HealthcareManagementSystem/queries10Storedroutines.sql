-- Active: 1671786369069@@127.0.0.1@3308@healthcare

/*Problem Statement 1:
The healthcare department has requested a system to analyze the performance of
 insurance companies and their plan.
For this purpose, create a stored procedure that returns the performance of
 different insurance plans of an insurance company. When passed the 
 insurance company ID the procedure should generate and return all the 
 insurance plan names the provided company issues, the number of treatments 
 the plan was claimed for, and the name of the disease the plan was claimed for the most. 
 The plans which are claimed more are expected to appear above the plans that are claimed less.
*/

DELIMITER //
CREATE PROCEDURE get_maxclaimed_plan_details(IN company_id INT)
BEGIN
    select  ip.planname,d.diseasename,count(t.claimid) as no_of_claims,
        dense_rank() over(order by count(t.claimid) desc ) as rnk
        from
        insurancecompany ic left join insuranceplan ip using(companyid)
        left join claim c using(UIN)
        inner join treatment t using(claimid)
        inner join disease d using(diseaseid)
        where ic.companyid=company_id
        group by ip.planname,d.diseasename
        order by rnk asc;
END//
DELIMITER;

call get_maxclaimed_plan_details(2295);
call get_maxclaimed_plan_details(1118);


/*
Problem Statement 2:
It was reported by some unverified sources that some pharmacies are more popular for certain diseases. 
The healthcare department wants to check the validity of this report.
Create a stored procedure that takes a disease name as a parameter and 
would return the top 3 pharmacies the patients are preferring for the treatment 
of that disease in 2021 as well as for 2022.
Check if there are common pharmacies in the top 3 list for a disease, 
in the years 2021 and the year 2022.
Call the stored procedure by passing the values “Asthma” and “Psoriasis” as disease names 
and draw a conclusion from the result.

*/
DELIMITER //
create procedure get_top3_pharmacies_of_disease(IN disease_name varchar(100))
BEGIN
    select p.pharmacyname,d.diseasename,count(ph.prescriptionid) as no_of_pres,
    dense_rank() over(order by count(ph.prescriptionid) desc) as drnk
    from 
    treatment t left join prescription ph using(treatmentid)
    inner join pharmacy p using(pharmacyid)
    inner join disease d using(diseaseid)
    where year(t.date) in (2021,2022) and d.diseasename=disease_name
    group by p.pharmacyname,d.diseasename
    order by drnk asc,p.pharmacyname
    limit 3;
END//
DELIMITER;

call get_top3_pharmacies_of_disease("Asthma");
call get_top3_pharmacies_of_disease("Psoriasis");


/*
Problem Statement 3:
Jacob, as a business strategist, wants to figure out if a state is appropriate for setting up 
an insurance company or not.
Write a stored procedure that finds the num_patients, 
num_insurance_companies, and insurance_patient_ratio,
 the stored procedure should also find the avg_insurance_patient_ratio 
 and if the insurance_patient_ratio of the given state is less than the
  avg_insurance_patient_ratio then it Recommendation section 
  can have the value “Recommended” otherwise the value can be “Not Recommended”.
Description of the terms used:
num_patients: number of registered patients in the given state
num_insurance_companies:  The number of registered insurance companies in the given state
insurance_patient_ratio: The ratio of registered patients and the number of insurance companies in the given state
avg_insurance_patient_ratio: The average of the ratio of registered patients and the number of insurance for all the states.

*/
DELIMITER //
create procedure is_inscompanay_setupOK_in(IN i_state VARCHAR(10))
BEGIN
    with cte as
        (select a.state,count(  pt.patientid) as num_patients,count(distinct ic.companyid) as num_insurance_companies,
        count(distinct ic.companyid)/count( pt.patientid) as insurance_patient_ratio,
        avg(count(distinct ic.companyid)/count(pt.patientid)) over(order by count(distinct ic.companyid)/count(pt.patientid) desc) as avg_ip_ratio
        from 
        address a left join person p using(addressid)
        inner join insurancecompany ic using(addressid)
        inner join patient pt on p.personid=pt.patientid
        inner join treatment t using(patientid)
        where state=i_state
        group by a.state)
    select * ,if(insurance_patient_ratio<avg_ip_ratio,"Recommended","Not Recommended") from cte;
END//
DELIMITER;

call is_inscompanay_setupOK_in("MA");

/*
Problem Statement 4:
Currently, the data from every state is not in the database, 
The management has decided to add the data from other states and cities as well. 
It is felt by the management that it would be helpful if the date and time were 
to be stored whenever new city or state data is inserted.
The management has sent a requirement to create a PlacesAdded table 
if it doesn’t already exist, that has four attributes. placeID, placeName,
 placeType, and timeAdded.

Description
placeID: This is the primary key, it should be auto-incremented starting from 1
placeName: This is the name of the place which is added for the first time
placeType: This is the type of place that is added for the first time. The value can either be ‘city’ or ‘state’
timeAdded: This is the date and time when the new place is added
You have been given the responsibility to create a system that satisfies 
the requirements of the management. Whenever some data is inserted in the Address table 
that has a new city or state name, the PlacesAdded table should be updated with relevant data. 
*/

create table new_places
(
    placeid int primary key AUTO_INCREMENT,
    placeName VARCHAR(65) NOT NULL,
    placeType ENUM('city','state'),
    timeAdded DATETIME 

);
ALTER TABLE new_places AUTO_INCREMENT=1;

select * from address limit 10;

DELIMITER //
CREATE TRIGGER collect_newplace
BEFORE INSERT ON address
for each row
BEGIN 

    IF new.city not in (select city from address) then 
        insert into new_places(placename,placetype,timeadded) values(new.city,'city',now());
    ELSEIF new.state not in (select state from address) 
        then insert into new_places(placename,placetype,timeadded) values(new.state,'state',now());
    END IF;

END//

DELIMITER;

select * from new_places ;


insert into address values(121241,"guntur-01","Edmond","OK",78777);
insert into address values(111241,"guntur-01","Guntur","AP",77777);
insert into address values(131241,"guntur-01","Edmond","AA",79777);
insert into address values(141241,"guntur-01","Vizag","OK",79777);


/*
Problem Statement 5:
Some pharmacies suspect there is some discrepancy in their inventory management. 
The quantity in the ‘Keep’ is updated regularly and there is no record of it. 
They have requested to create a system that keeps track of all the transactions
 whenever the quantity of the inventory is updated.
You have been given the responsibility to create a system that automatically 
updates a Keep_Log table which has  the following fields:
id: It is a unique field that starts with 1 and increments by 1 for each new entry
medicineID: It is the medicineID of the medicine for which the quantity is updated.
quantity: The quantity of medicine which is to be added. If the quantity is reduced 
then the number can be negative.
For example:  If in Keep the old quantity was 700 and the new quantity
 to be updated is 1000, then in Keep_Log the quantity should be 300.
Example 2: If in Keep the old quantity was 700 and the new quantity to be updated is 100, 
then in Keep_Log the quantity should be -600.

*/

create table keep_log
(
    id int primary key AUTO_INCREMENT,
    medicineid int,
    quantity int

);
alter table keep_log AUTO_INCREMENT=1;

select * from keep limit 5;

DELIMITER //
CREATE TRIGGER keep_update_register
AFTER UPDATE on keep
for each row
BEGIN 
    IF new.quantity>old.quantity then 
        insert into keep_log(medicineid,quantity) values(old.medicineid,new.quantity-old.quantity);
    ELSEIF new.quantity<old.quantity then 
        insert into keep_log(medicineid,quantity) values(old.medicineid,old.quantity-new.quantity);
    END IF;
END //

DELIMITER ;

update keep set quantity=6949 where pharmacyid=1008 and medicineid=1111;

update keep set quantity=6008 where pharmacyid=1008 and medicineid=1266;

select * from keep_log;













