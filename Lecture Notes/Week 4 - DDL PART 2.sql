/* 
Lecture June 10
TITLE: Week 4 - Joins and Views Part 2
DESCRIPTION: 
*/ 

-- List all employees and the city and phone number for their office

SELECT EmployeeNumber, 
       firstName || ' ' || lastName,
       city,
       phone,
       extension
       FROM employees e LEFT JOIN offices o ON e.officeCode = o.officeCode
       ORDER BY lastName;
       
-- change this to
-- List all Offices and the employees that work at them
SELECT  o.OfficeCode, 
        EmployeeNumber, 
        firstName || ' ' || lastName,
        city,
        phone,
        extension
    FROM employees e RIGHT JOIN offices o ON e.officeCode = o.officeCode
    ORDER BY lastName;

-- List all customers and their sales contact's phone number and extension
SELECT  customerNumber, 
        customerName, 
        employeeNumber, 
        firstName, lastName, 
        o.phone, extension
    FROM customers c LEFT JOIN employees e 
            ON c.salesRepEmployeeNumber = e.employeeNumber
        LEFT JOIN offices o ON e.officeCode = o.officeCode
    ORDER BY customerName;
    
-- equivalent to
SELECT  customerNumber, 
        customerName, 
        employeeNumber, 
        firstName, lastName, 
        o.phone, extension
    FROM employees e JOIN offices o USING (officeCode)
        RIGHT JOIN customers c ON c.salesRepEmployeeNumber = e.employeeNumber
    ORDER BY customerName;

-- VIEWS
-- The creation of VIEWS is a DDL statement that contains a DML statement

-- What is a view?
-- nothing more tan the storage or savings of an SQL DML statement

CREATE VIEW vwListCustomersAndSalesman AS
    SELECT  customerNumber, 
        customerName, 
        employeeNumber, 
        firstName, lastName, 
        o.phone, extension
    FROM employees e JOIN offices o USING (officeCode)
        RIGHT JOIN customers c ON c.salesRepEmployeeNumber = e.employeeNumber
    ORDER BY customerName;

SELECT * FROM vwListCustomersAndSalesman;

-- Views can be recalled at any time, and they produce real time data
CREATE OR REPLACE VIEW vwEmployees AS
    SELECT * FROM employees;
    

SELECT * FROM vwEmployees;

SELECT * FROM (SELECT * FROM employees);
-- this is silly but works

-- more real example
-- List all customer who do not have a sales rep
SELECT * FROM vwListCustomersAndSalesman
    WHERE employeeNumber IS NULL;
    

SELECT * FROM (SELECT  customerNumber, 
                        customerName, 
                        employeeNumber, 
                        firstName, lastName, 
                        o.phone, extension
                    FROM employees e JOIN offices o USING (officeCode)
                        RIGHT JOIN customers c ON c.salesRepEmployeeNumber = e.employeeNumber
                    ORDER BY customerName)
    WHERE employeeNumber IS NULL;
    

-- Views can be recalled at any time, and they produce real time data