![banner](https://i.imgur.com/qpNQXq4.jpg)
# VaxVax-Database-Design

Relational database design and MySQL implementation for a conceptual COVID-19 Vaccination Database that aggregates government and private citizen vaccination data. 

## Database Design
**Relational entity relationship diagram**
![](https://i.imgur.com/Y2nIvr8.jpg)
![](https://i.imgur.com/Y2nIvr8.jpg)

### External models for government entities and users
![](https://i.imgur.com/VHg0ArC.jpg)
![](https://i.imgur.com/vtUj6mZ.jpg)

### Example Queries
For all queries: [`vaxvaxquery.sql`](vaxvaxquery.sql)
**Average Adverse Effect Rating for 20-30, 30-40, and 40-50 Year Olds**
```sql
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
```

**Users name and SSN who are overdue for 2nd vaccine dose**

```sql
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
```

### Built With
- MySQLWorkbench, SQL 
- [Mockaroo Data Generator](https://www.mockaroo.com/)