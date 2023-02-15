-- Active: 1671786369069@@127.0.0.1@3308@healthcare

/*
Problem Statement 1:
Patients are complaining that it is often difficult to find some medicines. 
They move from pharmacy to pharmacy to get the required medicine. 
A system is required that finds the pharmacies and their contact number 
that have the required medicine in their inventory. So that the patients 
can contact the pharmacy and order the required medicine.
Create a stored procedure that can fix the issue.
*/


select * from medicine limit 10;

DELIMITER //
create procedure find_pharmacy_medicine(IN company_name varchar(100),IN product_name varchar(100))
BEGIN
    select distinct ph.pharmacyname,ph.phone ,k.quantity
    from 
    pharmacy ph inner join keep k using(pharmacyid)
    inner join medicine m using(medicineid)
    where companyname=company_name and productname=product_name;
END //
DELIMITER ;

call find_pharmacy_medicine("MARJAN INDUSTRIA E COMERCIO LTDA","OSTENAN");


/*
Problem Statement 2:
The pharmacies are trying to estimate the average cost of all the prescribed medicines 
per prescription, for all the prescriptions they have prescribed in a particular year.
 Create a stored function that will return the required value when the pharmacyID and 
 year are passed to it. Test the function with multiple values.
*/
DELIMITER //
create procedure get_avg_pres_val(IN pharmacy_id int,IN yr int)
BEGIN
    select avg(pres_val)  from
        (select pr.prescriptionid,sum(c.quantity*m.maxprice) as pres_val from 
        pharmacy ph left join prescription pr using(pharmacyid) 
        inner join treatment t using(treatmentid)
        inner join contain c using(prescriptionid)
        inner join medicine m using(medicineid)
        where year(t.date)=yr and ph.pharmacyid=pharmacy_id
        group by pr.prescriptionid) D;
END//
DELIMITER;

call get_avg_pres_val(1008,2021);
call get_avg_pres_val(1008,2022);


/*
Problem Statement 3:
The healthcare department has requested an application that finds out the disease 
that was spread the most in a state for a given year. So that they can use the information 
to compare the historical data and gain some insight.
Create a stored function that returns the name of the disease for which the patients 
from a particular state had the most number of treatments for a particular year. 
Provided the name of the state and year is passed to the stored function
*/
DELIMITER//
CREATE procedure get_max_disease(IN yr int,IN i_state varchar(10))
BEGIN
    select diseasename,no_of_treatments from
        (select d.diseasename,count(t.treatmentid) as no_of_treatments,
        dense_rank() over(order by count(t.treatmentid) desc) as drnk
        from 
        address a left join person p using(addressid)
        inner join treatment t on p.personid=t.patientid
        inner join disease d on d.diseaseid=t.diseaseid
        where year(t.date)=yr and a.state=i_state
        group by d.diseasename )D
    where drnk=1;
END//
DELIMITER;

call get_max_disease(2021,"TN");

/*
Problem Statement 4:
The representative of the pharma union, Aubrey, has requested a system that she can use to 
find how many people in a specific city have been treated for a specific disease in a specific 
year.
Create a stored function for this purpose.

*/
DELIMITER//
CREATE FUNCTION diseaseCount(icity varchar(50),yr int,disname varchar(100))
RETURNS INT
DETERMINISTIC
BEGIN
    declare dcount int; 
    select count(t.treatmentid) into dcount from 
    address a left join person p using(addressid)
    inner join treatment t on p.personid=t.patientid
    inner join disease d using(diseaseid)
    where a.city=icity and year(t.date)=yr and d.diseasename=disname;
    return dcount;
END//
DELIMITER;

select  diseasecount("Edmond",2020,"Asthma");






/*
Problem Statement 5:
The representative of the pharma union, Aubrey, is trying to audit different 
aspects of the pharmacies. She has requested a system that can be used to 
find the average balance for claims submitted by a specific insurance company 
in the year 2022. 
Create a stored function that can be used in the requested application. 

*/

DELIMITER//
CREATE FUNCTION AvgBalance(company_name varchar(100),yr int)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    declare avg_bal decimal(10,2);
    select avg(c.balance) into avg_bal from 
    treatment t inner join claim c using(claimid)
    inner join insuranceplan ip using(UIN)
    inner join insurancecompany ic using(companyid)
    where ic.companyname=company_name and year(t.date)=yr ;
    return avg_bal;
END//
DELIMITER;



select AvgBalance("Star Health and Allied Insurrance Co. Ltd.",2020);
select AvgBalance("Tata AIG General Insuarnce Co Ltd",2020);

