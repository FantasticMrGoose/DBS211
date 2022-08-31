-- Question 1a
SELECT employeeNumber, firstName, lastName, city, phone, postalCode
    FROM employees, offices
    WHERE employees.officecode = offices.officecode
        AND UPPER(country) = 'FRANCE';

-- Question 1b
SELECT employeeNumber, firstName, lastName, city, phone, postalCode
    FROM employees JOIN offices USING (officecode)
    WHERE UPPER(country) = 'FRANCE';
    
-- Question 2a
SELECT * FROM payments JOIN customers USING(customerNumber)
    WHERE UPPER(country) = 'CANADA'
    ORDER BY customerNumber;

-- Question 2b and c
SELECT customerNumber, 
       customerName, 
       TO_CHAR(paymentDate, 'MON DD, YYYY') AS paymentDate, 
       amount 
    FROM payments JOIN customers USING(customerNumber)
    WHERE UPPER(country) = 'CANADA'
    ORDER BY customerNumber;

-- Question 3
SELECT customerNumber, customerName 
    FROM customers LEFT JOIN payments USING(customerNumber)
    WHERE UPPER(country) = 'USA' 
        AND amount IS NULL
    ORDER BY customerNumber;
    
-- Question 4a
CREATE VIEW vwCustomerOrder AS
    SELECT customerNumber, 
           orderNumber, 
           TO_CHAR(orderDate, 'MON DD, YYYY') AS orderDate,
           productName,
           quantityOrdered,
           priceEach
    FROM customers LEFT JOIN orders USING (customernumber)
        LEFT JOIN orderDetails USING (orderNumber)
        LEFT JOIN products USING (productCode);
        
-- Question 4b
SELECT * FROM vwCustomerOrder;

-- Question 5
SELECT FROM vwCustomerOrder 
        LEFT JOIN orderDetails USING (ordernumber)
    WHERE customerNumber = 124
    ORDER BY orderNumber, orderlinenumber;
    
SELECT COUNT(*) FROM vwCustomerOrder;

-- Question 6
SELECT customerNumber, 
       contactfirstName AS firstName, 
       contactlastName AS lastName, 
       phone,
       creditLimit
    FROM customers LEFT JOIN orders USING (customerNumber)
    WHERE orderNumber IS NULL;
    
-- Question 7
CREATE VIEW vwEmployeeManager AS
    SELECT e1.*,
           e2.firstName || ' ' || e2.lastName AS managerName
    FROM employees e1 LEFT JOIN employees e2 
        ON e1.reportsTO = e2.employeeNumber;

SELECT * FROM vwEmployeeManager;        

-- Question 8
CREATE OR REPLACE VIEW vwEmployeeManager AS
    SELECT e1.*,
           e2.firstName || ' ' || e2.lastName AS managerName
    FROM employees e1 LEFT JOIN employees e2 
        ON e1.reportsTO = e2.employeeNumber
    WHERE e1.reportsTo IS NOT NULL;

SELECT * FROM vwEmployeeManager;     

-- Question 9
DROP VIEW vwCustomerOrder;
DROP VIEW vwEmployeeManager;



    