-- Active: 1671786369069@@127.0.0.1@3308@healthcare


/*
Problem Statement 1: 
Johansson is trying to prepare a report on patients who have gone through treatments 
more than once. Help Johansson prepare a report that shows the patient's name, 
the number of treatments they have undergone, and their age, Sort the data in a way 
that the patients who have undergone more treatments appear on top.
*/

select p.personname,TIMESTAMPDIFF(YEAR,pt.dob,now()) as age , count(treatmentid) as no_of_treatments from 
treatment t left join patient pt using(patientid)
inner join person p on pt.patientid=p.personid
group by pt.patientid
having no_of_treatments>1
order by no_of_treatments desc;



/*
Problem Statement 2:  
Bharat is researching the impact of gender on different diseases, 
He wants to analyze if a certain disease is more likely to infect a certain gender or not.
Help Bharat analyze this by creating a report showing for every disease
 how many males and females underwent treatment for each in the year 2021. 
 It would also be helpful for Bharat if the male-to-female ratio is also shown.
*/

select diseasename,sum(male_patient_count) as m_count,
sum(female_patient_count) as f_count ,
sum(male_patient_count)/sum(female_patient_count) as male_to_female_ratio
from
    (select diseasename,
    case when gender="male" then patient_count end as male_patient_count,
    case when gender="female" then patient_count end as female_patient_count
    from
        (select d.diseasename,
        count(t.patientid) as patient_count,p.gender  from 
        treatment t inner join person p on t.patientid=p.personid
        inner join disease d using(diseaseid)
        group by d.diseasename,p.gender) D1
    order by diseasename) D2
group by diseasename
order by male_to_female_ratio desc;


select d.diseasename,
        sum(if(p.gender="male",1,0)) as male_patient_count,
        sum(if(p.gender="female",1,0)) as female_patient_count,
        sum(if(p.gender="male",1,0))/sum(if(p.gender="female",1,0)) as male_to_female_ratio
        from 
        treatment t inner join person p on t.patientid=p.personid
        inner join disease d using(diseaseid)
        group by d.diseasename
        order by male_to_female_ratio desc;





/*
Problem Statement 3:  
Kelly, from the Fortis Hospital management, has requested a report that shows for each disease, 
the top 3 cities that had the most number treatment for that disease.
Generate a report for Kelly’s requirement
*/

select diseasename,city,no_of_treatments from
(select d.diseasename,a.city,count(t.patientid) as no_of_treatments,
row_number() over(partition by d.diseasename order by count(t.patientid) desc) as rn
 from 
address a left join person p using(addressid)
inner join treatment t on t.patientid=p.personid
right join disease d using(diseaseid)
group by d.diseasename,a.city  
order by d.diseasename,no_of_treatments desc) D
where rn in (1,2,3);


/*
Problem Statement 4: 
Brooke is trying to figure out if patients with a particular disease are preferring some pharmacies 
over others or not, For this purpose, she has requested a detailed pharmacy report 
that shows each pharmacy name, and how many prescriptions they have prescribed for 
each disease in 2021 and 2022, She expects the number of prescriptions 
prescribed in 2021 and 2022 be displayed in two separate columns.
Write a query for Brooke’s requirement
*/

 
select ph.pharmacyname,d.diseasename,
sum(if(year(t.date)=2021,1,0)) as prescriptions_2021,
sum(if(year(t.date)=2022,1,0)) as prescriptions_2022
from 
disease d inner join treatment t using(diseaseid)
inner join prescription pr using(treatmentid)
inner join pharmacy ph using(pharmacyid)
group by ph.pharmacyname,d.diseasename
order by ph.pharmacyname,prescriptions_2021 desc;


/*
Problem Statement 5: 
Walde, from Rock tower insurance, has sent a requirement for a report that 
presents which insurance company is targeting the patients of which state the most. 
Write a query for Walde that fulfills the requirement of Walde.
Note: We can assume that the insurance company is targeting a region more
if the patients of that region are claiming more insurance of that company.
*/
select companyname,state,no_of_claims as max_claims
from
    (select ic.companyname,a.state,count(c.claimid) as no_of_claims,
    row_number() over(partition by ic.companyname order by count(c.claimid) desc) as rn
    from 
    Insurancecompany ic inner join insuranceplan ip using(companyid)
    inner join claim c using(UIN) 
    inner join treatment tr using(claimid)
    inner join person p on tr.patientid=p.personid
    inner join address a on a.addressid=p.addressid
    group by ic.companyname,a.state
    order by ic.companyname,no_of_claims desc) D 
where rn=1
;









