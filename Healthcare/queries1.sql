-- Active: 1671786369069@@127.0.0.1@3308@healthcare


use healthcare;

-------------------------PH1------------------------------------

---Problem statement1:
/*
Problem Statement 1:  Jimmy, from the healthcare department, has requested a report that shows how the number of treatments each age category of patients has gone through in the year 2022. 
The age category is as follows, Children (00-14 years), Youth (15-24 years), Adults (25-64 years), and Seniors (65 years and over).
Assist Jimmy in generating the report. 
*/

SELECT CASE WHEN TIMESTAMPDIFF(YEAR,pt.dob,NOW()) <15 THEN 'Children'
            WHEN TIMESTAMPDIFF(YEAR,pt.dob,NOW())>=15 AND TIMESTAMPDIFF(YEAR,pt.dob,NOW())<=24 THEN 'Youth'
            WHEN TIMESTAMPDIFF(YEAR,pt.dob,NOW())>=25 AND TIMESTAMPDIFF(YEAR,pt.dob,NOW())<=64 THEN 'Adults'
            ELSE 'Seniors' END AS age_Category,
COUNT(*) as no_of_treatments 
FROM patient pt
NATURAL JOIN treatment t
WHERE YEAR(t.date)=2022
GROUP BY `age_Category`;


with patientCte AS (
    SELECT `patientID`,TIMESTAMPDIFF(YEAR,dob,NOW()) AS `age` FROM patient
)
SELECT CASE WHEN age <15 THEN 'Children'
            WHEN age>=15 AND age<=24 THEN 'Youth'
            WHEN age>=25 AND age<=64 THEN 'Adults'
            ELSE 'Seniors' END AS `age_Category`,
COUNT(*) as `no_of_treatments` 
FROM patientCte p
NATURAL JOIN treatment t
WHERE YEAR(t.date)=2022
GROUP BY `age_Category`;



---Problem statement2;
/*
Jimmy, from the healthcare department, wants to know which disease is infecting people of which gender more often.
Assist Jimmy with this purpose by generating a report that shows for each disease the male-to-female ratio. Sort the data in a way that is helpful for Jimmy.

*/

select diseaseId,gender,count(*) 
from 
treatment natural join patient 
inner join person 
on person.personId=patient.patientId 
group by diseaseId,gender order by diseaseId;

select diseaseId,
sum(case when gender="female" then 1 else 0 end ) as female,
sum(case when gender="male" then 1 else 0 end) as male
from 
treatment natural join patient 
inner join person 
on person.personId=patient.patientId 
group by diseaseId order by diseaseId;


select diseaseId,
sum(if(gender="female",1,0) )as female,
sum(if(gender="male",1,0)) as male
from 
treatment natural join patient 
inner join person 
on person.personId=patient.patientId 
group by diseaseId order by diseaseId;


----problem statement3;
/*
Jacob, from insurance management, has noticed that insurance claims are not made for all the treatments. 
He also wants to figure out if the gender of the patient has any impact on the insurance claim. 
Assist Jacob in this situation by generating a report that finds for each gender the number of treatments,
 number of claims, and treatment-to-claim ratio. 
 And notice if there is a significant difference 
 between the treatment-to-claim ratio of male and female patients.
*/

select gender,
count(treatmentId),
count(claimId),
count(claimId)/count(treatmentId) as claim_to_treatment_ratio 
--rank() over(order by count(claimid) desc ) as rnk

from treatment left join claim using(claimid) 
inner join person on person.personId=treatment.patientId 
group by gender;




--problem statement4;
/*
The Healthcare department wants a report about the inventory of pharmacies.
Generate a report on their behalf that shows how many units of medicine each pharmacy has in their inventory, 
the total maximum retail price of those medicines, and the total price of all the medicines after discount. 
Note: discount field in keep signifies the percentage of discount on the maximum price.

*/

select D.pharmacyid ,count(D.medicineid) as variety_of_medicines,
sum(D.quantity) as total_units,
sum(D.totalval) as total_value
from
    (select 
    pharmacyid,
    keep.medicineid,
    quantity,
    maxprice,
    discount,
    (quantity*maxprice)*(1-0.01*discount) as totalval from pharmacy ph left join keep using(pharmacyid) natural join medicine) as D
group by D.pharmacyid
order by total_value desc;
;

SELECT `pharmacyID`,COUNT(`medicineID`) as variety_of_medicines,ROUND(sum(`maxPrice`*quantity)) as val_without_dis, ROUND(SUM((`maxPrice`*quantity)*(1-0.01*discount))) as total_value
FROM pharmacy
NATURAL JOIN keep
NATURAL JOIN medicine
GROUP BY `pharmacyID`
ORDER BY total_value desc;






---problem statement5;
/*
The healthcare department suspects that some pharmacies prescribe more medicines than others 
in a single prescription, for them, generate a report that finds for each pharmacy the maximum, 
minimum and average number of medicines prescribed in their prescriptions. 
*/

select D.pharmacyid,
avg(D.max_quantity) as avg_of_max_quantity,
avg(D.min_quantity) as avg_of_min_quantity,
avg(D.avg_quantity) as avg_of_avg_quantity
from
    (select p.prescriptionid,p.pharmacyid,
    max(c.quantity) as max_quantity,
    min(c.quantity) as min_quantity,
    avg(c.quantity) as avg_quantity 
    from prescription p inner join contain c  on p.prescriptionid=c.prescriptionid 
    group by p.pharmacyid,p.prescriptionid 
    order by p.pharmacyid) as D
 group by D.pharmacyid
 order by avg_of_avg_quantity limit 10;


 select distinct pharmacyname,
--count(medicineid) as no_of_medicines,
max(count(medicineid)) over(partition by pharmacyname  ) as max_no_of_med_per_prescription,
min(count(medicineid)) over(partition by pharmacyname  ) as min_no_of_med_per_prescription,
avg(count(medicineid)) over(partition by pharmacyname  ) as avg_no_of_med_per_prescription
 from 
 pharmacy ph inner join prescription p using(pharmacyid)
 inner join contain c using(prescriptionid)
 group by pharmacyname,prescriptionid
 ;

 

---------------------------------------------




 select distinct pharmacyname,
--count(medicineid) as no_of_medicines,
max(sum(quantity)) over(partition by pharmacyname  ) as max_quantity_per_prescription,
min(sum(quantity)) over(partition by pharmacyname  ) as min_quantity_per_prescription,
avg(sum(quantity)) over(partition by pharmacyname  ) as avg_quantity_per_prescription
 from 
 pharmacy ph inner join prescription p using(pharmacyid)
 inner join contain c using(prescriptionid)
 group by pharmacyname,prescriptionid
 order by avg_quantity_per_prescription desc
;