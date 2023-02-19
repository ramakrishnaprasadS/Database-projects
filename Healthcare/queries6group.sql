-- Active: 1671786369069@@127.0.0.1@3308@healthcare


/*Problem Statement 1: 
The healthcare department wants a pharmacy report on the percentage of hospital-exclusive 
medicine prescribed in the year 2022.
Assist the healthcare department to view for each pharmacy, 
the pharmacy id, pharmacy name, total quantity of medicine prescribed in 2022,
total quantity of hospital-exclusive medicine prescribed by the pharmacy in 2022,
 and the percentage of hospital-exclusive medicine to the total medicine prescribed in 2022.
Order the result in descending order of the percentage found. 
*/

with cte as
    (select ph.pharmacyname,
    sum(c.quantity) as total_quantity_2022,
    sum(if(m.hospitalExclusive="S",c.quantity,0)) as HEX_quantity_2022
    from 
    pharmacy ph inner join prescription pr using(pharmacyid)
    inner join treatment t using(treatmentid)
    inner join contain c using(prescriptionid)
    inner join medicine m using(medicineid)
    where year(t.date)=2022
    group by ph.pharmacyname
    order by ph.pharmacyname)
select pharmacyname,total_quantity_2022,HEX_quantity_2022,
(HEX_quantity_2022*100)/total_quantity_2022 as HEX_medicine_percent
from cte
order by HEX_medicine_percent desc;


select ph.pharmacyname,
    sum(c.quantity) as total_quantity_2022,
    sum(if(m.hospitalExclusive="S",c.quantity,0)) as HEX_quantity_2022,
    (sum(if(m.hospitalExclusive="S",c.quantity,0))*100)/sum(c.quantity) as HEX_medicine_percent
    from 
    pharmacy ph inner join prescription pr using(pharmacyid)
    inner join treatment t using(treatmentid)
    inner join contain c using(prescriptionid)
    inner join medicine m using(medicineid)
    where year(t.date)=2022
    group by ph.pharmacyname
    order by HEX_medicine_percent desc;



/*
Problem Statement 2:  
Sarah, from the healthcare department, has noticed many people do not claim insurance for 
their treatment. She has requested a state-wise report of the percentage of treatments that
 took place without claiming insurance. Assist Sarah by creating a report 
 as per her requirement.
*/

select a.state,
count(t.treatmentid)-count(t.claimid) as total_treatments_notClaimed,
count(t.treatmentid) as total_treatments,
((count(t.treatmentid)-count(t.claimid))/count(t.treatmentid))*100 as  unClaimed_percentage
 from 
address a left join person p using(addressid)
inner join treatment t on p.personid = t.patientid
group by a.state;




/*
Problem Statement 3:  
Sarah, from the healthcare department, is trying to understand if some diseases are spreading
 in a particular region. Assist Sarah by creating a report which shows for each state,
  the number of the most and least treated diseases by the patients of that state 
  in the year 2022.
*/

with cte as
    (select a.state,d.diseasename,count(t.treatmentid) as no_of_treatments
    
    from
    address a inner join person p using(addressid)
    inner join treatment t on t.patientid=p.personid
    inner join disease d using(diseaseid)
    where year(t.date)=2021
    group by a.state,d.diseasename
    order by a.state,no_of_treatments desc)
select distinct state,
FIRST_VALUE(diseasename) over(partition by state) as max_diseasename,
FIRST_VALUE(no_of_treatments) over(partition by state) as max_treatments,
LAST_VALUE(diseasename) over(partition by state) as min_diseasename,
LAST_VALUE(no_of_treatments) over(partition by state) as min_treatments
from cte
;


select count(distinct state) from address; 

/*
Problem Statement 4: 
Manish, from the healthcare department, wants to know how many 
registered people are registered as patients as well, 
in each city. Generate a report that shows each city 
that has 10 or more registered people belonging to it and 
the number of patients from that city as well as 
the percentage of the patient with respect to the registered people.

*/

select a.city,count(p.personid) as no_of_persons,count(pt.patientid) as no_of_patients,
(count(pt.patientid)/count(p.personid))*100 as patient_percentage
from address a left join person p using(addressid)
left join patient pt on p.personid=pt.patientid
group by a.city
having no_of_persons>=10;

/*
Problem Statement 5:  
It is suspected by healthcare research department that the substance “ranitidine” might
 be causing some side effects. Find the top 3 companies using the substance in their 
 medicine so that they can be informed about it.
*/
select * from
    (select *,dense_rank() over( order by no_of_medicines desc) as drnk from
        (select companyname,count(medicineid) as no_of_medicines 
        from medicine 
        where substancename like "ranitidina" or substancename like "ranitidina%"
        group by companyname
        order by no_of_medicines desc) D1) D2
 where drnk in (1,2,3)   ;





select * from
        (select companyname,count(medicineid) as no_of_medicines,
        dense_rank() over(order by count(medicineid) desc) as drnk 
        from medicine 
        where substancename like "ranitidina" or substancename like "ranitidina%"
        group by companyname
        order by no_of_medicines desc) D1
 where drnk in (1,2,3);