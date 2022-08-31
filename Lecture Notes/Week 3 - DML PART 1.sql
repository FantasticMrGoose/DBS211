/* **********
AUTHOR: Clint MacDonald 100######
DATE: June 1, 2021
TITLE: Week 3 - DML Part 1
DESCRIPTION: Introduction to SQL in general
*/

-- SQL - Structured Query Langauge

-- DDL, DML, TCL
-- DML - Data Manipulation Language - viewing and changing the data
-- DDL - Data Definition Language - Defining the structure of the database.
-- TCL - Transaction Control Langauge

-- DATA MANIPULATION LANGUAGE
-- The basic SELECT statement

-- there are 7 parts to a SELECT statement, we will start with 2 of them.
-- there are 2 parts that are mandatory.
--    SELECT and FROM

-- SELECT <comma seperated field list> FROM <tablename>
SELECT customerNumber, customerName, creditLimit
    FROM customers;
    
-- Given me EVERYTHING from a specific table
SELECT * FROM customers;

-- calculated fields
SELECT customerNumber, customerName, creditLimit, creditLimit * 1.10
    FROM customers;

SELECT CONCAT(CONCAT(contactFirstName, ' '), contactLastName)
    FROM customers;

SELECT contactFirstName || ' ' || contactLastName
    FROM customers;

-- aliases (there are two types of aliases - field and table)
-- field aliases are names given to fields or columns
SELECT  customerNumber, 
        customerName, 
        contactFirstName || ' ' || contactLastName AS fullName, 
        creditLimit
    FROM customers;
-- another example
SELECT customerNumber, customerName, creditLimit, creditLimit * 1.10 AS newLimit
    FROM customers;
    
-- SORTING or ORDERING
-- by default output is sorting by an indexed primary key
-- ORDER BY <comma separated field list>
SELECT customerNumber, customerName, creditLimit
    FROM customers
    ORDER BY creditLimit;
    -- by default sorting is done in Ascending (ASC) order
SELECT customerNumber, customerName, creditLimit
    FROM customers
    ORDER BY creditLimit DESC;  -- descending
    
SELECT  customerNumber, 
        customerName, 
        creditLimit, 
        creditLimit * 1.10 AS newLimit
    FROM customers
    ORDER BY newLimit;
    
    -- there are 3 ways to sort things
    -- NUMERIC (math)
    -- ALPHABETIC (spelling)
    -- CHRONOLOGICAL (date and time)

SELECT  customerNumber, 
        customerName, 
        creditLimit, 
        '$' || TO_CHAR(creditLimit * 1.10, 0999999.00) AS newLimit
    FROM customers
    ORDER BY newLimit;  
    -- if you include a string in the calculation, the alias is defined as a string
    -- therefore sorting is alpahbetical, not numeric in this case.
SELECT  customerNumber, 
        customerName, 
        creditLimit, 
        '$' || creditLimit * 1.10 AS newLimit
    FROM customers
    ORDER BY creditLimit * 1.10; 
    
-- filtering, limiting the result, only getting a subset of the data
-- WHERE <condition(s) as a boolean logical expression>
SELECT  customerNumber, 
        customerName, 
        creditLimit, 
        creditLimit * 1.10 AS newLimit
    FROM customers
    WHERE creditLimit = 0
    ORDER BY newLimit; 
    
    -- gotcha
SELECT  customerNumber, 
        customerName, 
        creditLimit, 
        creditLimit * 1.10 AS newLimit
    FROM customers
    WHERE newLimit = 0
    ORDER BY newLimit; 
        -- FAILS
        
-- ORDER OF EXECUTION
-- an SQL does not execute start to finish, or top down
-- There is a specifc order in qhich the clauses execute.
-- FROM, WHERE, SELECT (LOOP), ORDER BY

-- so what if i need a WHERE clause on a calculated field
SELECT  customerNumber, 
        customerName, 
        creditLimit, 
        creditLimit * 1.10 AS newLimit
    FROM customers
    WHERE creditLimit * 1.10 = 0
    ORDER BY newLimit; 

--  single line functions
SELECT  customerNumber, 
        customerName, 
        creditLimit, 
        ROUND(creditLimit * 1.13345, 2) AS withTax
    FROM customers
    WHERE creditLimit > 0
    ORDER BY withTax; 
    
-- String WILDCARDS and the LIKE operator
-- 
SELECT contactFirstName || ' ' || contactLastName AS fullName
    FROM customers
    WHERE contactLastName LIKE 'S%';
    
SELECT contactFirstName || ' ' || contactLastName AS fullName
    FROM customers
    WHERE contactLastName LIKE 's%';  -- sting are case sensitive
    
    -- what if I want results no matter what...
SELECT contactFirstName || ' ' || contactLastName AS fullName
    FROM customers
    WHERE LOWER(contactLastName) LIKE 's%';
    

-- Bad database or software design
-- Clint Macdonald  is WRONG   Clint MacDonald



    