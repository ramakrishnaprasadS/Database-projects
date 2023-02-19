-- Active: 1671786369069@@127.0.0.1@3308@healthcare

use healthcare;


/*Problem Statement 1:  
Some complaints have been lodged by patients that they have been prescribed 
hospital-exclusive medicine that they can’t find elsewhere and facing problems due to that.
 Joshua, from the pharmacy management, wants to get a report of 
 which pharmacies have prescribed hospital-exclusive medicines the most in the years 2021 and 2022.
  Assist Joshua to generate the report so that the pharmacies who prescribe hospital-exclusive medicine 
  more often are advised to avoid such practice if possible.   */



select ph.pharmacyname,count(m.medicineid) as no_of_HEX_varieties_sold,sum(c.quantity) as total_qty_sold from 
pharmacy ph inner join prescription pr using(pharmacyid)
inner join treatment t on pr.treatmentid = t.treatmentid
inner join contain c on  pr.prescriptionid = c.prescriptionID
inner join medicine m on c.medicineid = m.medicineid
where m.hospitalExclusive = "S" and (year(t.date) in (2021,2022))
group by ph.pharmacyname
order by total_qty_sold desc;



/*
Problem Statement 2: 
Insurance companies want to assess the performance of their insurance plans. 
Generate a report that shows each insurance plan, the company that issues the plan, 
and the number of treatments the plan was claimed for.
*/

--Q3--PS2
select ic.companyname,ip.planname,count(c.claimid) as no_of_treatments_claimed from 
insurancecompany ic inner join insuranceplan ip using(companyid)
inner join claim c using(UIN)
group by ic.companyname,ip.planname
order by ic.companyname,no_of_treatments_claimed desc;


/*
Problem Statement 3: 
Insurance companies want to assess the performance of their insurance plans. 
Generate a report that shows each insurance company's name with their most 
and least claimed insurance plans.
*/

--Q3--PS3
with cte as 
(
    select ic.companyname,ip.planname,count(t.claimid) as no_of_treatments_claimed from 
    insurancecompany ic inner join insuranceplan ip using(companyid)
    inner join claim c using(UIN)
    inner join treatment t using (claimid)
    group by ic.companyname,ip.planname
    order by ic.companyname,no_of_treatments_claimed desc
)
select companyname,planname,no_of_treatments_claimed from
    (select companyname,planname,no_of_treatments_claimed,
    max(no_of_treatments_claimed) over(partition by companyname) max_in_company,
    min(no_of_treatments_claimed) over(partition by companyname) min_in_company
    FROM cte
    ) D
where 
no_of_treatments_claimed=max_in_company or no_of_treatments_claimed=min_in_company;


with cte as 
(
    select ic.companyname,ip.planname,count(t.claimid) as no_of_treatments_claimed ,
    max(count(t.claimid)) over(partition by companyname ) max_in_company,
    min(count(t.claimid)) over(partition by companyname ) min_in_company
    from 
    insurancecompany ic inner join insuranceplan ip using(companyid)
    inner join claim c using(UIN)
    inner join treatment t using (claimid)
    group by ic.companyname,ip.planname
    order by ic.companyname,no_of_treatments_claimed desc
)
select  companyname,
case when no_of_treatments_claimed=max_in_company then planname end as max_claimed_plan,
case when no_of_treatments_claimed=min_in_company then planname end as min_claimed_plan
 from cte
where 
no_of_treatments_claimed=max_in_company or no_of_treatments_claimed=min_in_company
order by companyname,no_of_treatments_claimed desc;


with cte AS (SELECT `companyName`,`planName`, COUNT(`claimID`) 'claimCount'
FROM insurancecompany
INNER JOIN insuranceplan USING (`companyID`)
LEFT JOIN claim USING(uin)
GROUP BY `companyName`,`planName`
ORDER BY `companyName`,claimCount DESC
)
SELECT DISTINCT`companyName`, 
FIRST_VALUE(`planName`) OVER(PARTITION BY `companyName`) 'MaxClaim',
LAST_VALUE(`planName`) OVER(PARTITION BY `companyName`) 'MinClaim'
FROM cte
ORDER BY `companyName`;


/*
Problem Statement 4:  
The healthcare department wants a state-wise health report to assess which state requires more attention in the healthcare sector.
 Generate a report for them that shows the state name, number of registered people in the state, 
 number of registered patients in the state, and the people-to-patient ratio. 
 sort the data by people-to-patient ratio.
*/

select a.state,count(p.personid) as no_of_persons,
count(pt.patientid) as no_of_patients,
count(p.personid)/count(pt.patientid) as people_to_patient_ratio
from person p inner join address a using(addressid) 
left join patient pt on p.personid = pt.patientid 
group by a.state
order by no_of_patients desc;


/*Problem Statement 5:  
Jhonny, from the finance department of Arizona(AZ), has requested a report that lists the 
total quantity of medicine each pharmacy in his state has prescribed that falls 
under Tax criteria I for treatments that took place in 2021. Assist Jhonny 
in generating the report. */

select ph.pharmacyname,sum(c.quantity) as total_quantity
 from 
address a inner join pharmacy ph using(addressid)
inner join prescription pr using(pharmacyid)
inner join treatment t using(treatmentid)
left join contain c using(prescriptionid)
inner join medicine m using(medicineid)
where a.state="AZ" and m.taxcriteria="I" and year(t.date)=2021
group by ph.pharmacyname
order by total_quantity desc
;















