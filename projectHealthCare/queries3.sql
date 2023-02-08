-- Active: 1671786369069@@127.0.0.1@3308@healthcare

use healthcare;


/*Problem Statement 1:  
Some complaints have been lodged by patients that they have been prescribed 
hospital-exclusive medicine that they can’t find elsewhere and facing problems due to that.
 Joshua, from the pharmacy management, wants to get a report of 
 which pharmacies have prescribed hospital-exclusive medicines the most in the years 2021 and 2022.
  Assist Joshua to generate the report so that the pharmacies who prescribe hospital-exclusive medicine 
  more often are advised to avoid such practice if possible.   */



with cte as
(select ph.pharmacyid,count(m.medicineid) as no_of_HEX_medicines,sum(c.quantity) as total_qty from 
pharmacy ph inner join prescription pr using(pharmacyid)
inner join treatment t on pr.treatmentid = t.treatmentid
inner join contain c on  pr.prescriptionid = c.prescriptionID
inner join medicine m on c.medicineid = m.medicineid
where m.hospitalExclusive = "S" and (year(t.date) in (2021,2022))
group by ph.pharmacyid
)
select phr.pharmacyname,cte.pharmacyID,cte.no_of_HEX_medicines,cte.total_qty
from pharmacy phr inner join cte using(pharmacyid)
order by cte.no_of_HEX_medicines desc
limit 20;


/*
Problem Statement 2: 
Insurance companies want to assess the performance of their insurance plans. 
Generate a report that shows each insurance plan, the company that issues the plan, 
and the number of treatments the plan was claimed for.
*/

--Q3--PS2
select ic.companyname,ip.planname,count(t.claimid) as no_of_treatments_claimed from 
insurancecompany ic inner join insuranceplan ip using(companyid)
inner join claim c using(UIN)
inner join treatment t using (claimid)
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


/*
Problem Statement 4:  
The healthcare department wants a state-wise health report to assess which state requires more attention in the healthcare sector.
 Generate a report for them that shows the state name, number of registered people in the state, 
 number of registered patients in the state, and the people-to-patient ratio. 
 sort the data by people-to-patient ratio.
*/

select a.state,count(p.personid) as no_of_persons,
count(pt.patientid) as no_of_patients
from person p inner join address a using(addressid) 
left join patient pt on p.personid = pt.patientid 
group by a.state
order by no_of_patients desc;


/*Problem Statement 5:  
Jhonny, from the finance department of Arizona(AZ), has requested a report that lists the 
total quantity of medicine each pharmacy in his state has prescribed that falls 
under Tax criteria I for treatments that took place in 2021. Assist Jhonny 
in generating the report. */

select ph.pharmacyid,sum(c.quantity) as total_quantity
 from 
address a inner join pharmacy ph using(addressid)
inner join prescription pr using(pharmacyid)
left join contain c using(prescriptionid)
inner join medicine m using(medicineid)
where a.state="AZ" and m.taxcriteria="I"
group by ph.pharmacyID
order by total_quantity desc
limit 10;















