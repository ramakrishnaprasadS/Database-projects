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





