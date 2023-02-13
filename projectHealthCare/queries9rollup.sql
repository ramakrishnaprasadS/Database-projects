-- Active: 1671786369069@@127.0.0.1@3308@healthcare

/*
Problem Statement 1: 
Brian, the healthcare department, has requested for a report that shows for each state 
how many people underwent treatment for the disease “Autism”.  He expects the report to
 show the data for each state as well as each gender and for each state and gender combination. 
Prepare a report for Brian for his requirement.
*/


select 
a.state,
sum(if(p.gender="male",1,0)) as "no_of_males_treated" ,
sum(if(p.gender="female",1,0)) as "no_of_females_treated" 
from
treatment t inner join disease d using(diseaseid)
inner join person p on t.patientid = p.personid 
inner join address a using(addressid)
where d.diseasename="Autism"
group by a.state
;

SELECT  state,IFNULL(gender, 'Total') AS Gender, IFNULL(COUNT(`treatmentID`), 'Total') AS 'Total'
FROM address
INNER JOIN person USING(`addressID`)
INNER JOIN patient ON person.`personID`=`patient`.`patientID` 
INNER JOIN treatment USING(`patientID`)
INNER JOIN disease USING(`diseaseID`)
WHERE `diseaseName` = 'Autism'
GROUP BY state,gender WITH ROLLUP;

/*
Problem Statement 2:  
Insurance companies want to evaluate the performance of different insurance plans they offer. 
Generate a report that shows each insurance plan, the company that issues the plan,
and the number of treatments the plan was claimed for. 
The report would be more relevant if the data compares the performance
for different years(2020, 2021 and 2022) and if the report also includes 
the total number of claims in the different years, as well as the total number of claims 
for each plan in all 3 years combined.
*/

select 
ic.companyname,ip.planname,
sum(if(year(t.date)=2020,1,0)) as "2020-claims",
sum(if(year(t.date)=2021,1,0)) as "2021-claims",
sum(if(year(t.date)=2022,1,0)) as "2022-claims",
sum(if(year(t.date) in (2020,2021,2022),1,0)) as "total-3yrs-claims"
from 
treatment t inner join claim c using(claimid) 
inner join insuranceplan ip using(UIN)
inner join insurancecompany ic using(companyid)
group by ic.companyname,ip.planname;


SELECT `planName`,IFNULL(`companyName`,'Total'), YEAR(date) AS 'year',COUNT(`treatmentID`)
FROM insurancecompany
INNER JOIN insuranceplan USING(`companyID`)
INNER JOIN claim USING(UIN)
INNER JOIN treatment USING(`claimID`)
WHERE YEAR(date) IN (2020,2021,2022)
GROUP BY `planName`,`companyName`,year WITH ROLLUP;


/*
Problem Statement 3:  
Sarah, from the healthcare department, is trying to understand if some diseases are 
spreading in a particular region. Assist Sarah by creating a report which shows 
each state the number of the most and least treated diseases by the patients of
 that state in the year 2022. It would be helpful for Sarah if the aggregation 
 for the different combinations is found as well. 
 Assist Sarah to create this report. 
*/

select ct1.state,top_diseases,no_of_top_diseases,least_diseases,no_of_least_diseases from 
    (select state,
    case when top_ranks=1 then group_concat(diseasename) end as top_diseases,
    case when top_ranks=1 then count(diseasename) end as no_of_top_diseases
    from
        (select state,diseasename,no_of_treatments,
        DENSE_RANK() over(partition by state order by no_of_treatments desc) as top_ranks
        
        from
            (select a.state,d.diseasename,count(t.patientid) as no_of_treatments from 
            treatment t inner join disease d using(diseaseid)
            inner join person p on t.patientid=p.personid
            inner join address a using(addressid)
            where year(t.date)=2021
            group by a.state,d.diseasename
            order by a.state) D1) D2
    where top_ranks=1
    group by state) ct1
inner join 
    (select state,
    case when least_ranks=1 then group_concat(diseasename) end as least_diseases,
    case when least_ranks=1 then count(diseasename) end as no_of_least_diseases
    from
        (select state,diseasename,no_of_treatments,
        
        DENSE_RANK() over(partition by state order by no_of_treatments asc) as least_ranks
        from
            (select a.state,d.diseasename,count(t.patientid) as no_of_treatments from 
            treatment t inner join disease d using(diseaseid)
            inner join person p on t.patientid=p.personid
            inner join address a using(addressid)
            where year(t.date)=2021
            group by a.state,d.diseasename
            order by a.state) D1) D2
    where least_ranks=1
    group by state) ct2
on ct1.state=ct2.state;


---not working ??
select state,
case when top_ranks=1 then group_concat(diseasename) end as top_diseases,
case when top_ranks=1 then count(diseasename) end as no_of_top_diseases,
case when least_ranks=1 then group_concat(diseasename) end as least_diseases,
case when least_ranks=1 then count(diseasename) end as no_of_least_diseases
from
    (select state,diseasename,no_of_treatments,
    DENSE_RANK() over(partition by state order by no_of_treatments desc) as top_ranks,
    DENSE_RANK() over(partition by state order by no_of_treatments asc) as least_ranks
    from
        (select a.state,d.diseasename,count(t.patientid) as no_of_treatments from 
        treatment t inner join disease d using(diseaseid)
        inner join person p on t.patientid=p.personid
        inner join address a using(addressid)
        where year(t.date)=2021
        group by a.state,d.diseasename
        order by a.state) D1) D2
where top_ranks=1 or least_ranks=1
group by state
;


/*
Problem Statement 4: 
Jackson has requested a detailed pharmacy report that shows each pharmacy name, 
and how many prescriptions they have prescribed for each disease in the year 2022, 
along with this Jackson also needs to view how many prescriptions were prescribed by 
each pharmacy, and the total number prescriptions were prescribed for each disease.
Assist Jackson to create this report. 
*/


select ph.pharmacyname,ifnull(d.diseasename,"total"),count(pr.prescriptionid)
from 
pharmacy ph inner join prescription pr using(pharmacyid)
inner join treatment t using(treatmentid)
inner join disease d using(diseaseid)
where year(t.date)=2021
group by ph.pharmacyname,d.diseasename with rollup
;



/*
Problem Statement 5:  
Praveen has requested for a report that finds for every disease how many males and females
 underwent treatment for each in the year 2022. It would be helpful for Praveen 
 if the aggregation for the different combinations is found as well.
Assist Praveen to create this report. 
*/

select d.diseasename,ifnull(p.gender,"total"),count(t.treatmentid) as no_of_treatments  
from 
treatment t inner join disease d using(diseaseid)
inner join person p on t.patientid= p.personid
group by d.diseasename,p.gender with rollup;

















