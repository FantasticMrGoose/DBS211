-- Question 1
/* How many tables have been created? List the names of the created tables. */

/* 8 tables have been created. 
   CUSTOMERS
   EMPLOYEES
   OFFICES
   ORDERDETAILS
   ORDERS
   PAYMENTS
   PRODUCTLINES
   PRODUCTS
*/


-- Question 2
/* There are 122 rows in the customers table */

-- Question 3
   SELECT COUNT(1) FROM "DBS211_212D39"."CUSTOMERS";


-- Question 4
/* There are 13 columns in the customers table
   CUSTOMERNUMBER
   CUSTOMERNAME
   CONTACTLASTNAME
   CONTACTFIRSTNAME
   PHONE
   ADDRESSLINE1
   ADDRESSLINE2
   CITY
   STATE
   POSTALCODE
   COUNTRY
   SALESREPEMPLOYEENUMBER
   CREDITLIMIT
*/


-- Question 5

/* COLUMN NAME            DATA TYPE VALUE
   CUSTOMERNUMBER         NUMBER    103
   CUSTOMERNAME           VARCHAR2  Atelier graphique
   CONTACTLASTNAME        VARCHAR2  Schmitt
   CONTACTFIRSTNAME       VARCHAR2  Carine 
   PHONE                  VARCHAR2  40.32.2555
   ADDRESSLINE1           VARCHAR2  54, rue Royale
   ADDRESSLINE2           VARCHAR2  (null)
   CITY                   VARCHAR2  Nantes
   STATE                  VARCHAR2  (null)
   POSTALCODE             VARCHAR2  44000
   COUNTRY                VARCHAR2  France
   SALESREPEMPLOYEENUMBER NUMBER    1370
   CREDITLIMIT            NUMBER    21000
*/


-- Question 6
/* 
   TABLE NAME   ROWS   COLUMNS
   CUSTOMER     122    13
   EMPLOYEES    23     8
   OFFICES      7      8
   ORDERDETAILS 2996   5
   ORDERS       326    7
   PAYMENTS     273    4
   PRODUCTLINES 7      4
   PRODUCTS     110    9
*/


-- Question 7
/* The order details table includes 2996 rows */


-- Question 8
/* A table is shown displaying the name, whether if the data is nullable,
   and the data type of the column*/
   

-- Question 9
/* SELECT * FROM employees; 
    displays all the rows within the EMPLOYEES table

   SELECT * FROM customers ORDER BY ContactLastName; 
    displays all the rows within the CUSTOMERS table, but sorts them in 
    ascending alphabetical order by the column CONTACTLASTNAME*/
    
-- Question 10
/* The PRODUCTS table has 11 constraints*/


-- Question 11
/* The gutter is the vertical space to the left of a line that displays the 
   line number.
<- The space the arrow is pointing to would be the gutter. */


-- Question 12
/* I set the font size to 20 */