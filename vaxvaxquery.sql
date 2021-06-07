-- GROUP 1 MILESTONE QUERIES
-- REVISION: FINAL
-- DATE: 5/14/21, 8:00PM
-- LATEST AUTHOR: NARISSA
-- NOTE: THESE ARE THE EXACT QUERIES COPIED INTO THE MILESTONE SUBMITTAL 

use team_1_new_db;

#--------------------------------------------------------------------------------------------------------------------
/* Q1. Total Number of VaxVax Users*/
select 
	count(distinct user_info.user_id) as 'Total Number of VaxVax Users'
from user_info;

#--------------------------------------------------------------------------------------------------------------------

/* Q2. Percentage of Users Who Have Received 1st Vaccine Dose */
select
	ROUND((((select count(x.user_id) from
	(select user_id, dose_num, vaccine_date from date_administered
	where (dose_num = 1 and dose_num != 2)) as x
	left join
	(select user_id, dose_num, vaccine_date from date_administered
	where (dose_num = 2)) as y on y.user_id = x.user_id
	where y.user_id is null) / count(distinct date_administered.user_id)) * 100), 2)
as 'Percentage of Users Who Have Only Received 1st Vaccine Dose' from date_administered;

#--------------------------------------------------------------------------------------------------------------------

/* Q3. Percentage of Users Who Have Received */
select 
	ROUND((select count(distinct vaccine.user_id)  from vaccine
	where vaccine.dose_num = 2) / ((select count(distinct vaccine.user_id)  from vaccine
	where vaccine.dose_num = 2) + count(distinct vaccine.user_id)) * 100, 2) 
	as 'Percentage of Users Who Have Received 2nd Vaccine Dose' from vaccine
where vaccine.dose_num = 1;

#--------------------------------------------------------------------------------------------------------------------

/* Q4. Percentage of Users Who Have Not Recorded Their Second Dose More Than
		4 Weeks After Recording the 1st Vaccine Dose (May-15-2021)*/
select 
	ROUND(count(x.user_id)/ (select count(x.user_id) 
from (
		select user_id , dose_num, vaccine_date from date_administered
		where (dose_num = 1  and dose_num !=2)) as x
		left join (select user_id , dose_num , vaccine_date from date_administered
		where (dose_num = 2)) as y on y.user_id = x.user_id
		where y.user_id is null) * 100, 2) as 'Percent 2nd Shot Not Recorded' 
from (
		select user_id , dose_num, vaccine_date from date_administered
		where (dose_num = 1  and dose_num !=2)) as x
 left join (select user_id, dose_num, vaccine_date from date_administered
 where (dose_num = 2)) as y on y.user_id = x.user_id
 where y.user_id is null and x.vaccine_date < CAST('2021-04-15' AS DATE);

#--------------------------------------------------------------------------------------------------------------------

/* Q5. Average Adverse Effect Rating by Manufacturer */
select 
	adverse_effects.manufacturer as 'Manufacturer', 
    ROUND(avg(adverse_effects.adverse_effects_rating), 1) as 'Average Adverse Effect Rating' from adverse_effects
group by adverse_effects.manufacturer
order by 'Average Adverse Effect Rating', manufacturer;

#--------------------------------------------------------------------------------------------------------------------

/* Q6. Average Adverse Effect Rating for 20-30, 30-40, and 40-50 Year Olds - column display */
select 
	ROUND(avg(adverse_effects.adverse_effects_rating), 2) as 'Avg. Adverse Effect Rating, Age = 20-30', 
    ROUND((select 
				avg(adverse_effects.adverse_effects_rating) from adverse_effects
				inner join user_info on adverse_effects.user_id = user_info.user_id
				where user_info.date_of_birth between CAST('1980-1-01' AS DATE) and CAST('1990-1-01' AS DATE)), 2) 
                as 'Avg. Adverse Effect Rating, Age = 30-40', 
	ROUND((select 
				avg(adverse_effects.adverse_effects_rating) as side_effect_in_age_group_40_50 from adverse_effects
				inner join user_info on adverse_effects.user_id = user_info.user_id
				where user_info.date_of_birth between CAST('1970-1-01' AS DATE) and CAST('1980-1-01' AS DATE)), 2) 
				as 'Avg. Adverse Effect Rating, Age = 40 - 50' 
from adverse_effects
inner join user_info on adverse_effects.user_id = user_info.user_id
where user_info.date_of_birth between CAST('1990-1-01' AS DATE) and CAST('2000-1-01' AS DATE);

#--------------------------------------------------------------------------------------------------------------------

/* Q7. Average Adverse Effect Rating, by Gender*/
select 
	gender as 'Gender', 
    ROUND(avg(adverse_effects.adverse_effects_rating), 2) as 'Average Adverse Effect Rating' 
from adverse_effects
inner join user_info on adverse_effects.user_id = user_info.user_id
group by  user_info.gender;

#--------------------------------------------------------------------------------------------------------------------

/* Q8. Percentage of User’s Gender, by State */
select 
    state as 'State',
	gender as 'Gender',
	count(gender) as 'User Count'
from user_info
group by state
order by state, gender;

#--------------------------------------------------------------------------------------------------------------------

/*Q9. List of Reported Medical Authorities in Washington State*/
select 
	medical_authority.ma_name as 'Medical Authority', 
    location_address.city as 'City',
    medical_authority.ma_phone_number as 'Phone'
from medical_authority 
join location_administered on medical_authority.medical_authority_id = location_administered.medical_authority_id
join location_address on location_administered.location_id = location_address.location_id
where state = 'Washington'
order by ma_name;

 #--------------------------------------------------------------------------------------------------------------------

/*Q10*/
 /*getting user name and SSN of user who are over due with second shot vaccine*/
 select 
	x.user_id as 'User ID', 
    x.vaccine_date as 'Vaccine Date', 
    user_info.first_name as 'First Name', 
    user_info.last_name as 'Last Name', 
    user_info.social_security_numer as 'Social Security Number'
from
 (select user_id , dose_num, vaccine_date from date_administered
 where (dose_num = 1  and dose_num !=2)) as x
 left join 
 (select user_id , dose_num , vaccine_date from date_administered
 where (dose_num = 2)) as y on y.user_id = x.user_id
 inner join user_info on x.user_id = user_info.user_id
 where y.user_id is null and x.vaccine_date < CAST('2021-04-15' AS DATE);

 #--------------------------------------------------------------------------------------------------------------------

/*Q11*/
 /*checking to see which user have blue cross blue shield insurance*/
 select 
	insurance.last_name as 'Last Name',
    insurance.first_name as 'First Name',
	insurance.user_id as 'User ID'
from insurance
 where insurance_provider = 'BlueCross Blue Shield'
 order by insurance.last_name, insurance.first_name;


#--------------------------------------------------------------------------------------------------------------------

 /* NOT USED -  average adverse effect between 20-50 by 10 years - row display */
select  user_info.date_of_birth as Age_increment_by_10_years, avg(adverse_effects.adverse_effects_rating) as Side_effect_by_age_group from adverse_effects
inner join user_info on adverse_effects.user_id = user_info.user_id
where user_info.date_of_birth between CAST('1990-1-01' AS DATE) and CAST('2000-1-01' AS DATE)
or user_info.date_of_birth between CAST('1980-1-01' AS DATE) and CAST('1990-1-01' AS DATE)  
or user_info.date_of_birth between CAST('1970-1-01' AS DATE) and CAST('1980-1-01' AS DATE)
group by user_info.date_of_birth between CAST('1990-1-01' AS DATE) and CAST('2000-1-01' AS DATE) 
, user_info.date_of_birth between CAST('1980-1-01' AS DATE) and CAST('1990-1-01' AS DATE)  
, user_info.date_of_birth between CAST('1970-1-01' AS DATE) and CAST('1980-1-01' AS DATE)
order by user_info.date_of_birth desc ;
 




#--------------------------------------------------------------------------
  /* Q4 CHECK - validate count of user who have not have 2nd shot*/
select count(x.user_id) from
 (select user_id , dose_num, vaccine_date from date_administered
 where (dose_num = 1  and dose_num !=2)) as x
 left join 
 (select user_id , dose_num , vaccine_date from date_administered
 where (dose_num = 2)) as y on y.user_id = x.user_id
 where y.user_id is null;
 
 /*Q4 CHECK - validate user who second shot is pass due or over 4 weeks*/
select count(x.user_id)
from
 (select user_id , dose_num, vaccine_date from date_administered
 where (dose_num = 1  and dose_num !=2)) as x
 left join 
 (select user_id , dose_num , vaccine_date from date_administered
 where (dose_num = 2)) as y on y.user_id = x.user_id
 where y.user_id is null and x.vaccine_date < CAST('2021-04-15' AS DATE);

/*Q4 CHECK - user ID that have the 1st shot but not second shot*/
select x.user_id, x.dose_num, x.vaccine_date
from
 (select user_id , dose_num, vaccine_date from date_administered
 where (dose_num = 1  and dose_num !=2)) as x
 left join 
 (select user_id , dose_num , vaccine_date from date_administered
 where (dose_num = 2)) as y on y.user_id = x.user_id
 where y.user_id is null and x.vaccine_date < CAST('2021-04-15' AS DATE);

