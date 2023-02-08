-- Active: 1671786369069@@127.0.0.1@3308@healthcare


use healthcare;

/*Problem Statement 1: 
A company needs to set up 3 new pharmacies, 
they have come up with an idea that the pharmacy can be set up in 
cities where the pharmacy-to-prescription ratio is the lowest and the number of prescriptions 
should exceed 100. 
Assist the company to identify those cities where the pharmacy can be set up.*/

 select a.city,
 count(pr.prescriptionid) as pres_cnt,
 count(distinct p.pharmacyid) as pharmacy_cnt, 
 count(pr.prescriptionid)/count(distinct p.pharmacyid) as prescr_pharmacy_ratio 
 from address a left join pharmacy p using(addressid) 
 inner join prescription pr on p.pharmacyid=pr.pharmacyid 
 group by a.city 
 having pres_cnt>100
 order by prescr_pharmacy_ratio desc limit 10;


/*
Problem Statement 2: 
The State of Alabama (AL) is trying to manage its healthcare resources more efficiently.
For each city in their state, they need to identify the disease for which 
the maximum number of patients have gone for treatment. Assist the state for this purpose.
Note: The state of Alabama is represented as AL in Address Table.

*/
select city,diseaseid,treat_cnt from
(select city,diseaseid,treat_cnt,max(treat_cnt) over( partition by city) as max_cnt 
from
 (select a.city,t.diseaseid,count( t.treatmentid) as treat_cnt
 from treatment t inner join person p on t.patientid=p.personid  
 inner join address a on p.addressid=a.addressid 
  where a.state="AL" 
  group by a.city,t.diseaseid
  order by a.city asc ) D  ) D2
  where treat_cnt=max_cnt 
  order by max_cnt desc;


/*
Problem Statement 3:
 The healthcare department needs a report about insurance plans.
  The report is required to include the insurance plan,
   which was claimed the most and least for each disease.  
   Assist to create such a report.
*/

select diseasename ,planname,no_of_claims from
(select d.diseasename,i.planname,count(claimid) as no_of_claims ,
max(count(claimid)) over(partition by d.`diseasename`) as max_claims,
min(count(claimid)) over(partition by d.`diseasename`) as min_claims
from disease d inner join treatment t using(diseaseid) inner join claim c using(claimid) inner join insuranceplan i using(UIN)
group by d.diseasename,i.planname order by d.diseasename desc) D
where no_of_claims = max_claims or no_of_claims = min_claims order by diseasename asc,no_of_claims desc limit 100;


/*
Problem Statement 4: 
The Healthcare department wants to know which disease is most likely to infect multiple people 
in the same household. For each disease find the number of households 
that has more than one patient with the same disease. 
Note: 2 people are considered to be in the same household if they have the same address. 
*/

select a.addressid,d.diseasename,count(t.patientid) as no_of_patients from
address a inner join person p using(addressid) inner join treatment t on p.personid=t.patientid
inner join disease d using(diseaseid)
group by a.addressid,d.diseasename
having no_of_patients > 1
order by a.addressid asc ,no_of_patients desc,d.diseasename asc
limit 100;


/*
Problem Statement 5:  
An Insurance company wants a state wise report of the 
treatments to claim ratio between 1st April 2021 and 31st March 2022 (days both included). 
Assist them to create such a report.
*/


select a.state,
count(t.treatmentId),
count(t.claimId),
count(t.treatmentId)/count(t.claimId) as treatment_to_claim_ratio
from
treatment t left join claim c on t.claimid=c.claimid 
inner join person p on p.personId=t.patientId 
right join address a on p.addressid=a.addressid
where date between ("2021-04-01") and ("2022-03-31")
group by a.state
order by treatment_to_claim_ratio desc
limit 20;


