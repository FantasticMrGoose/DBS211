SET AUTOCOMMIT ON;

-- QUESTION 1
SELECT * FROM offices;

-- QUESTION 2
SELECT employeenumber 
    FROM employees
    WHERE officecode = 1;
    
-- QUESTION 3
SELECT customernumber,
       customername,
       contactfirstname,
       contactlastname,
       phone
    FROM customers
    WHERE UPPER(city) = 'PARIS';
    
-- QUESTION 4
SELECT customernumber,
       customername,
       contactLastName || ' ' || contactFirstName AS fullName,
       phone
    FROM customers
    WHERE UPPER(country) = 'CANADA';

-- QUESTION 5
SELECT DISTINCT customernumber 
    FROM payments;

-- QUESTION 6
SELECT customernumber,
       checknumber,
       amount
    FROM payments
    WHERE amount < 30000 OR amount > 65000
    ORDER BY amount DESC;
    
-- QUESTION 7
SELECT * FROM orders 
    WHERE TRIM(status) = 'Cancelled';

-- QUESTION 8
SELECT productcode,
       productname,
       buyprice,
       msrp, 
       msrp - buyprice AS markup,
       round(100 * (msrp - buyprice)/buyprice,1) AS percmarkup
    FROM products;

-- QUESTION 9
SELECT * FROM products 
    WHERE LOWER(productname) LIKE 'co%';

-- QUESTION 10
SELECT * FROM customers 
    WHERE LOWER(contactfirstname) LIKE 's%' 
    AND LOWER(contactfirstname) LIKE '%e%';
    
-- QUESTION 11
INSERT INTO employees (employeenumber, lastname, firstname, extension, email, 
        jobtitle, officecode, reportsto)
    VALUES (2525, 'Zhou', 'Jeffrey', 'x554', 'zjzhou2@myseneca.ca', 
        'Cashier', 4, 1088);
        
-- QUESTION 12
SELECT * FROM employees
    WHERE employeenumber = 2525;
    
-- QUESTION 13
UPDATE employees SET jobtitle = 'Head Cashier'
    WHERE employeenumber = 2525;

-- QUESTION 14
INSERT INTO employees (employeenumber, lastname, firstname, extension, email, 
        jobtitle, officecode, reportsto)
    VALUES (3535, 'of Rivia', 'Geralt', 'x912', 'geraltofrivia@kaermorhen.com', 
        'Cashier', 4, 2525);
        
-- QUESTION 15
DELETE FROM employees
    WHERE employeenumber = 2525;
    
/* This delete statement did not work because employee 3535 reports to employee 
2525 thus the data are in a relationship. To prevent an orphaned record,
referential integrity prevents my data from being deleted*/

-- QUESTION 16
DELETE FROM employees
    WHERE employeenumber = 3535;

DELETE FROM employees
    WHERE employeenumber = 2525;

-- Yes, the delete statement worked

-- Question 17

INSERT ALL
    INTO employees VALUES (2525, 'Smith', 'John', 'x554', 
    'johnsmith2211@gmail.ca', 4, 1088, 'Cashier')
    INTO employees VALUES (3535, 'of Rivia', 'Geralt', 'x912', 
    'geraltofrivia@kaermorhen.com', 4, 1088, 'Cashier')
    SELECT * FROM dual;
    
-- QUESTION 18

DELETE FROM employees
    WHERE employeenumber = 2525 OR employeenumber = 3535;

