![banner](README_imgs\vaxvax-logo.jpg)
# VaxVax-Database-Design

Relational database design and MySQL implementation for a conceptual COVID-19 Vaccination Database that aggregates government and private citizen vaccination data. 

![**Design and Implementation Document**](https://github.com/narissatsuboi/vaxvax-covid-database/blob/main/VaxVax%20Database%20Design.pdf)

## Database Design
**Relational entity relationship diagram**
    ![](README_imgs\vaxvax-ERD.jpg)

**External models for government entities and users**
    ![](README_imgs\vaxvax-externalmodel-gov.jpg)
    ![](README_imgs\vaxvax-externalmodel-user.jpg)

**Example Querys and Stored Procedures**
![vaxvaxquery.sql](vaxvaxquery.sql). 
- Average adverse effect rating by manufacturer
- Users who used a specified insurance company for coverage 
- Number of users overdue for 2nd vaccine dose

<!-- ## API Documentation 
For detailed API documentation and available endpoints, refer to API_DOCUMENTATION.md.  -->

## Built With
- MySQLWorkbench, SQL 
- ![Mockaroo Data Generator](https://www.mockaroo.com/)