-- Active: 1671786369069@@127.0.0.1@3308@healthcare

/*
Problem Statement 1: 
“HealthDirect” pharmacy finds it difficult to deal with the product type of medicine 
being displayed in numerical form, they want the product type in words. 
Also, they want to filter the medicines based on tax criteria. 
Display only the medicines of product categories 1, 2, and 3 for medicines 
that come under tax category I and medicines of product categories 4, 5, and 6 for
medicines that come under tax category II.
Write a SQL query to solve this problem.
ProductType numerical form and ProductType in words are given by
1 - Generic, 
2 - Patent, 
3 - Reference, 
4 - Similar, 
5 - New, 
6 - Specific,
7 - Biological, 
8 – Dinamized

3 random rows and the column names of the Medicine table are given for reference.
Medicine (medicineID, companyName, productName, description, substanceName, productType, taxCriteria, hospitalExclusive, governmentDiscount, taxImunity, maxPrice)

*/

select 
m.medicineID,m.companyName,m.productName,m.description,m.substanceName,
case m.productType
    when 1 then "Genereic"
    when 2 then "Patent"
    when 3 then "Reference"
    when 4 then "Similar"
    when 5 then "New"
    when 6 then "Specific"
    when 7 then "Biological"
    when 8 then "Dinamized"
end as Product_Type,
m.taxCriteria,m.hospitalExclusive,m.governmentDiscount,m.taxImunity,m.maxPrice
 from 
pharmacy ph inner join keep k using(pharmacyid)
inner join medicine m using(medicineid)
where ph.pharmacyName="HealthDirect" and 
((m.productType in (1,2,3) and m.taxCriteria="I") or (m.productType in (4,5,6) and m.taxCriteria="II") )
ORDER BY m.taxCriteria;






/*
Problem Statement 2:  
'Ally Scripts' pharmacy company wants to find out the quantity of medicine prescribed in each of its prescriptions.
Write a query that finds the sum of the quantity of all the medicines in a prescription and 
if the total quantity of medicine is less than 20 tag it as “low quantity”. 
If the quantity of medicine is from 20 to 49 (both numbers including) tag it as “medium quantity“ 
and if the quantity is more than equal to 50 then tag it as “high quantity”.
Show the prescription Id, the Total Quantity of all the medicines in that prescription, and the Quantity tag for all the prescriptions issued by 'Ally Scripts'.
3 rows from the resultant table may be as follows:
prescriptionID	totalQuantity	Tag
1147561399		43			Medium Quantity
1222719376		71			High Quantity
1408276190		48			Medium Quantity

*/
with cte as 
    (select pr.prescriptionid,sum(c.quantity) as total_qty from 
    Prescription pr inner join contain c using(prescriptionid)
    inner join pharmacy ph using(pharmacyid)
    where ph.pharmacyName="Ally Scripts"
    group by pr.prescriptionid)
select prescriptionid,total_qty,
case 
    when total_qty<20 then "low quantity"
    when total_qty between 20 and 49  then "medium quantity"
    when total_qty>=50 then "high quantity"
    end as Tag
from cte;



/*
Problem Statement 3: 
In the Inventory of a pharmacy 'Spot Rx' the quantity of medicine is considered ‘HIGH QUANTITY’ 
when the quantity exceeds 7500 
and ‘LOW QUANTITY’ when the quantity falls short of 1000. The discount is considered “HIGH” 
if the discount rate on a product is 30% or higher, and the discount is considered “NONE” 
when the discount rate on a product is 0%.
 'Spot Rx' needs to find all the Low quantity products with high discounts and all the high-quantity 
 products with no discount so they can adjust the discount rate according to the demand. 
Write a query for the pharmacy listing all the necessary details relevant to the given requirement.

Hint: Inventory is reflected in the Keep table.

*/
with cte as
(   select k.medicineid ,k.quantity, 
    case 
        when k.quantity>7500 then "HIGH QUANTITY"
        when k.quantity<1000 then "LOW QUANTITY"
        else "OK"
        end as qty_status,
    case 
        when k.discount>30 then "HIGH"
        when k.discount=0 then "NONE"
        else "NORMAL"
        end as discount_status
    from keep k inner join pharmacy ph using(pharmacyid) where ph.`pharmacyName`="Spot Rx")
select medicineid,quantity,qty_status,discount_status from cte
where (qty_status="LOW QUANTITY" and discount_status="HIGH") or (qty_status="HIGH QUANTITY" and discount_status="NONE");


select k.medicineid ,k.quantity,k.discount
from keep k inner join pharmacy ph using(pharmacyid) where ph.`pharmacyName`="Spot Rx" and k.quantity<1000 and k.discount>30;


/*
Problem Statement 4: 
Mack, From HealthDirect Pharmacy, wants to get a list of all the affordable and costly, 
hospital-exclusive medicines in the database. Where affordable medicines are the medicines 
that have a maximum price of less than 50% of the avg maximum price of all the medicines in 
the database, and costly medicines are the medicines that have a maximum price of more than 
double the avg maximum price of all the medicines in the database. 
 Mack wants clear text next to each medicine name to be displayed that identifies 
 the medicine as affordable or costly. The medicines that do not fall under either of 
 the two categories need not be displayed.
Write a SQL query for Mack for this requirement.
*/

with cte as
    (select avg(maxprice) as avg_price from medicine)
select m.medicineid,m.maxPrice,cte.avg_price ,
case 
    when m.maxPrice<0.5*cte.avg_price then "affordable"
    when m.maxPrice>2*cte.avg_price then "costly"
    end as category
from 
pharmacy ph inner join keep k using(pharmacyID)
inner join medicine m using(medicineid)
cross join cte
where ph.pharmacyName="HealthDirect" and m.hospitalExclusive="S" and 
(m.maxPrice<0.5*cte.avg_price or m.maxPrice>2*cte.avg_price );


/*Problem Statement 5:  
The healthcare department wants to categorize the patients into the following category.
YoungMale: Born on or after 1st Jan  2005  and gender male.
YoungFemale: Born on or after 1st Jan  2005  and gender female.
AdultMale: Born before 1st Jan 2005 but on or after 1st Jan 1985 and gender male.
AdultFemale: Born before 1st Jan 2005 but on or after 1st Jan 1985 and gender female.
MidAgeMale: Born before 1st Jan 1985 but on or after 1st Jan 1970 and gender male.
MidAgeFemale: Born before 1st Jan 1985 but on or after 1st Jan 1970 and gender female.
ElderMale: Born before 1st Jan 1970, and gender male.
ElderFemale: Born before 1st Jan 1970, and gender female.

Write a SQL query to list all the patient name, gender, dob, and their category.
*/


select 
pt.patientid,p.personname,pt.dob,p.gender,
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
patient pt inner join person p on pt.patientid = p.personid
limit 20;




