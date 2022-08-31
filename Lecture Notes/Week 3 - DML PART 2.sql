/* Lecture June 3 2021 */
-- Week 3 - DML (CRUD) PART 2
-- Distinct
SELECT city FROM customers;
SELECT city FROM customers ORDER BY city;
--but we don't want repeats
SELECT DISTINCT city FROM customers ORDER BY city;
-- human error, has space but according to DB they are distinct
SELECT DISTINCT city, Country, postalcode FROM customers ORDER BY city;
-- row distinct
-- primary key is unique, so don't distinct by it

-- ORDER OF PRECEDENCE
-- an extension to Order of Operations
-- BEDMAS AO (AND OR)

SELECT 4 + 3 * 5 AS aNumber FROM dual; 
-- follows BEDMAS
-- ORDER OF 

-- we know the first name starts with R and the last name
-- starts with R
SELECT contactLastName, contactFirstName 
    FROM customers
    WHERE LOWER (contactLastName) LIKE 's%'
        OR LOWER(contactLastName) LIKE 'm%'
        AND LOWER(contactFirstName) LIKE 'r%';
-- order of precendence is AND occurs before OR
-- therefore we have to be careful writing the statement
-- to be what we actually meant
-- brackets to fix
SELECT contactLastName, contactFirstName 
    FROM customers
    WHERE (LOWER (contactLastName) LIKE 's%'
        OR LOWER(contactLastName) LIKE 'm%')
        AND LOWER(contactFirstName) LIKE 'r%';

-- User Input
SELECT DISTINCT city, country
    FROM customers
    WHERE UPPER(country) = 'CANADA';
-- if we want the country to be dynamic
SELECT DISTINCT city, country
    FROM customers
    WHERE LOWER(country) = '&EnterCountry';
    
-- we need to take care of human error on both sides 
SELECT DISTINCT city, country
    FROM customers
    WHERE TRIM (UPPER(country)) = TRIM(UPPER('&EnterCountry'));
        
-- TO_CHAR() function
SELECT customerNumber, creditLimit, '$' || ROUND(creditLimit,2) AS asMoney
    FROM customers;
    -- rounds to two decimal spots, but will show only if it exists

SELECT customerNumber, creditLimit, '$' || TO_CHAR(ROUND(creditLimit,2),'999999.99' ) 
            AS asMoney
    FROM customers
    ORDER BY asMoney;    
    -- note in this case it was still sorted Numerically
    -- can also use 0 as formatting for leading zeros ex: 999099.99

SELECT customerNumber,
       TO_CHAR(amount, '99999.99') AS amount
    FROM Payments;

-- Dates
-- very frustrating part of dbs, along with nulls
SELECT orderNumber, orderDate, shippedDate
    FROM orders;

SELECT orderNumber, orderDate, shippedDate
    FROM orders
    WHERE orderdate = '03-12-09';
    -- never hardcode dates like this (human interpretation)
    
-- ***DATES ARE STORED AS DECIMAL***
-- ALWAYS USE TO_DATE() WHEN HARD CODING DATES
SELECT orderNumber, orderDate, shippedDate
    FROM orders
    WHERE orderdate = TO_DATE('03-12-09', 'YY-MM-DD');
    --SPECIFY THE FORMAT

-- Give last 7 days orders
SELECT orderNumber
    FROM orders
    WHERE orderdate BETWEEN sysdate - 7 AND sysdate + 1;
    -- orders 7 days ago including today
    
-- NEXTDAY
SELECT orderNumber
    FROM orders
    WHERE orderdate BETWEEN sysdate AND NEXT_DAY(sysdate, 'Sunday');
    -- between sysdate and next day after the sysdate that is a sunday

-- Outputting Dates
SELECT * FROM orders;
-- FORMAT
SELECT sysdate FROM dual;
SELECT TO_CHAR(sysdate, 'Mon DD, YYY') AS dt FROM dual;

-- get orders in march
SELECT orderNumber, orderDate
    FROM orders
    WHERE EXTRACT(MONTH FROM orderDate)= 3
        AND EXTRACT(YEAR from orderDate) = 2004;
    -- extracts the 3rd month from the year 2003
    
-- CRUD
-- create, read, update, and delete
-- create is not create, but insert

-- INSERTING A NEW ROW
INSERT INTO offices (Officecode, city, phone, state, country, postalcode, 
        addressline1, addressline2, territory)
    VALUES (8, 'Toronto', '+1 905-555-1212', 'ON', 'CAN', 'M2J3S3', 
        'ad1','ad2','NA');
        
INSERT INTO offices
    VALUES (9, 'Oshawa', '+1 905-555-1212', 'ON', 'CAN', 'M2J3S3', 
        'ad1','ad2','NA');
        
INSERT INTO offices
    VALUES (11, 'Quebec', '+1 905-555-1212', 'ad1', NULL, 'ON', 'CAN', 'M2J3S3', 'NA');

-- CHANGE DATA
UPDATE offices SET city = 'Quebec City', phone = '+1 589-555-6666';
-- BAD BAD BAD - this gets you FIRED


UPDATE offices SET city = 'Quebec', phone = '+1 589-555-6666'
    WHERE officeCode = 11;
    
-- DELETE
DELETE FROM offices
    WHERE officeCode = 9;
    

-- DUAL table
SELECT * FROM dual
-- built in table
