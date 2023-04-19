


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
JOIN treatment t on pt.patientid=t.patientid
WHERE YEAR(t.date)=2022
GROUP BY `age_Category`;




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
count(t.treatmentId),
count(c.claimId),
count(c.claimId)/count(treatmentId)  as claim_to_treatment_ratio
from treatment t left outer join claim c on t.claimid=c.claimid 
join person on person.personId=t.patientId 
group by gender;






