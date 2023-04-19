-- Active: 1671786369069@@127.0.0.1@3308@healthcare

/*
Problem Statement 1: 
Insurance companies want to know if a disease is claimed higher or lower than average.  
Write a stored procedure that returns “claimed higher than average” or 
“claimed lower than average” when the diseaseID is passed to it. 
Hint: Find average number of insurance claims for all the diseases.  
If the number of claims for the passed disease is higher than the 
average return “claimed higher than average” otherwise “claimed lower than average”.
*/
DELIMITER //
create procedure disease_claim_status(IN dis_id INT)
BEGIN
    declare tot_avg_claims INT;
    declare no_claims_of_disease INT;
    
    select avg(d_claims) into tot_avg_claims from
        (select diseaseid,count(claimid) as d_claims
        from treatment group by diseaseid) D;

    select count(claimid) into no_claims_of_disease from treatment
    where diseaseid=dis_id; 

    if (no_claims_of_disease > tot_avg_claims)
        then SELECT dis_id as disease_id,no_claims_of_disease,tot_avg_claims,'Claimed Higher than Average' AS Claimed;
    else 
         SELECT dis_id as disease_id,no_claims_of_disease,tot_avg_claims,'Claimed Lowerr than Average' AS Claimed;
    end if;
END //
DELIMITER ;
call disease_claim_status(5);



/*
Problem Statement 2:  
Joseph from Healthcare department has requested for an application which helps him get 
genderwise report for any disease. 
Write a stored procedure when passed a disease_id returns 4 columns,
disease_name, number_of_male_treated, number_of_female_treated, more_treated_gender
Where, more_treated_gender is either ‘male’ or ‘female’ based on which gender 
underwent more often for the disease, if the number is same for both the genders, the value should be ‘same’.
*/
DELIMITER //
create procedure genderwise_treatment_report(IN dis_id INT)
BEGIN 
    DECLARE disease_name varchar(100);
    DECLARE no_of_male_treated int;
    DECLARE no_of_female_treated int;
    DECLARE more_treated_gender varchar(6);

    select d.diseasename,
    sum(if(p.gender="male",1,0)),
    sum(if(p.gender="female",1,0)) 
    into disease_name,no_of_male_treated,no_of_female_treated
    from treatment t left join disease d using(diseaseid)
    inner join person p on t.patientid=p.personid
    where t.diseaseid=dis_id
    group by diseasename;

    if (no_of_male_treated>no_of_female_treated) THEN
            set more_treated_gender="male";
            
    elseif (no_of_female_treated>no_of_male_treated) THEN
            SET more_treated_gender="female";
    ELSE
            set more_treated_gender="both";
    end if;

    select disease_name,no_of_male_treated,no_of_female_treated,more_treated_gender;
END//
DELIMITER;
call genderwise_treatment_report(9);


/*Problem Statement 3:  
The insurance companies want a report on the claims of different insurance plans. 
Write a query that finds the top 3 most and top 3 least claimed insurance plans.
The query is expected to return the insurance plan name, the insurance 
company name which has that plan, and whether the plan is the most claimed or least claimed. 
*/

DELIMITER //
create procedure check_claim_category(IN plan_name varchar(100))
BEGIN 
    DECLARE company_name varchar(100);
    DECLARE category_type varchar(50);
     
    with cte as
        (select companyname,planname,no_of_claims,
        dense_rank() over(order by no_of_claims desc) as top_rnks,
        dense_rank() over(order by no_of_claims asc) as least_rnks
        from
            (select  distinct ip.planname,ic.companyname,
            count(c.claimid) as no_of_claims
            from
            treatment t inner join claim c using(claimid)
            right join insuranceplan ip using(UIN)
            inner join insurancecompany ic using(companyid)
            group by ip.planname,ic.companyname
            ) D1)
    select companyname,category into company_name,category_type from
        (select companyname,planname,no_of_claims ,"most claimed" as category from cte
        where top_rnks in (1,2,3)
        union
        select companyname,planname,no_of_claims,"least claimed" as category from cte
        where least_rnks in (1,2,3)) Dl
    where planname=plan_name;
    IF (category_type IS NOT NULL) then select company_name,category_type;
    ELSE select "given plan name is not in top 3 or least 3 claimed list" as category;
    END IF;
END//
DELIMITER ;
call check_claim_category("Group Credit Secure Plus");
call check_claim_category("Surakshit Loan Bima");
call check_claim_category('Saral Suraksha Bima');



--------------------
    with cte as
        (select companyname,planname,no_of_claims,
        dense_rank() over(order by no_of_claims desc) as top_rnks,
        dense_rank() over(order by no_of_claims asc) as least_rnks
        from
            (select  distinct ip.planname,ic.companyname,
            count(c.claimid) over(partition by ip.planname) as no_of_claims
            from
            treatment t inner join claim c using(claimid)
            right join insuranceplan ip using(UIN)
            inner join insurancecompany ic using(companyid)
            ) D1)
    select companyname,planname ,no_of_claims,"most claimed"as category from cte
    where top_rnks in (1,2,3)
    order by top_rnks;

/*
Problem Statement 4: 
The healthcare department wants to know which category of patients is being affected the most by each disease.
Assist the department in creating a report regarding this.
Provided the healthcare department has categorized the patients into the following category.
YoungMale: Born on or after 1st Jan  2005  and gender male.
YoungFemale: Born on or after 1st Jan  2005  and gender female.
AdultMale: Born before 1st Jan 2005 but on or after 1st Jan 1985 and gender male.
AdultFemale: Born before 1st Jan 2005 but on or after 1st Jan 1985 and gender female.
MidAgeMale: Born before 1st Jan 1985 but on or after 1st Jan 1970 and gender male.
MidAgeFemale: Born before 1st Jan 1985 but on or after 1st Jan 1970 and gender female.
ElderMale: Born before 1st Jan 1970, and gender male.
ElderFemale: Born before 1st Jan 1970, and gender female.

*/

with cte as 
    (select pt.patientid,p.personname,pt.dob,p.gender,
    case 
        when pt.dob>="2005-01-01" and p.gender = "Male" then "YoungMale"
        when pt.dob>="2005-01-01" and p.gender = "female" then "YoungFemale"
        when pt.dob<"2005-01-01" and pt.dob>"1985-01-01" and p.gender = "Male" then "AdultMale"
        when pt.dob<"2005-01-01" and pt.dob>"1985-01-01" and p.gender = "Female" then "AdultFemale"
        when pt.dob<"1985-01-01" and pt.dob>"1970-01-01" and p.gender = "Male" then "MidAgeMale"
        when pt.dob<"1985-01-01" and pt.dob>"1970-01-01" and p.gender = "Female" then "MidAgeFemale"
        when pt.dob<="1970-01-01" and p.gender = "Male" then "YoungMale"
        when pt.dob<="1970-01-01" and p.gender = "Female" then "YoungFemale"
        end as age_group
    from 
    patient pt inner join person p on pt.patientid = p.personid)
select diseasename,age_group,patient_count 
    from 
    (select diseasename,age_group,patient_count,
    dense_rank() over(partition by diseasename order by patient_count desc) as drnk 
        from
        (select d.diseasename,cte.age_group,count(t.patientid) as patient_count
        from 
        cte inner join treatment t using(patientid)
        inner join disease d using(diseaseid)
        group by d.diseasename,cte.age_group
        order by d.diseasename,cte.age_group) D1) D2
where drnk=1
order by patient_count desc;


/*
Problem Statement 5:  
Anna wants a report on the pricing of the medicine. She wants a list of the most expensive 
and most affordable medicines only. 
Assist anna by creating a report of all the medicines which are pricey and affordable,
 listing the companyName, productName, description, maxPrice, and the price category of each. 
 Sort the list in descending order of the maxPrice.
Note: A medicine is considered to be “pricey” if the max price exceeds 1000 and
 “affordable” if the price is under 5. Write a query to find 
*/

select medicineid,productname,maxprice,
case 
    when maxprice<5 then "affordable"
    when maxprice>1000 then "pricey"
    end as cost_type
from medicine
where maxprice<5 or maxprice>1000;
























