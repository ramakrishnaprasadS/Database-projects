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

select d.diseasename,
count(t.patientid)  from 
treatment t inner join person p on t.patientid=p.personid
inner join disease d using(diseaseid)
group by d.diseasename,p.gender;