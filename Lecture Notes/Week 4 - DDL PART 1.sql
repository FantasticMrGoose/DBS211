/* 
Lecture June 8
TITLE: Week 4 - DML Continued - Joins
DESCRIPTION: Introduction to SQL in general continued
*/ 
-- Two types of Joins we will talk about
-- ANSI89 and ANSI92
-- Only ANSI92 should be used for NEW queries.
--DON'T use ANSI89 Joins unless asked for

-- List all the orders sorterd by customer
SELECT orderNumber, customerNumber
    FROM orders
    ORDER BY customerNumber;
    -- but who is customer 103?
    
SELECT customerNumber, customerName
    FROM customers
    WHERE customerNumber = 103;
    -- need data that is stored in multiple tables (customers and orders table)

-- ANSI89 Join
SELECT orderNumber, orders.customerNumber, customers.customerNumber, customerName
    FROM orders, customers
    WHERE orders.customerNumber = customers.customerNumber;
    -- The WHERE clause is mandatory for ANSI89 Joins
    
-- ANSI92 Join    
SELECT orderNumber, customerNumber, customerName
    FROM orders, customers;
    -- error as customerNumber exists in both tables and therefore is ambiguous.
    -- therefore we must give a table specifier before the fieldname

SELECT orderNumber, orders.customerNumber, customers.customerNumber, customerName
    FROM orders, customers;
-- but this gives us 39700 'ish rows or which most are wrong.  These are Tuples

SELECT orderNumber, orders.customerNumber, customers.customerNumber, customerName
    FROM orders, customers
    WHERE orders.customerNumber = customers.customerNumber;
    -- THE WHERE clause is MANDATORY for ANSI89 joins
    -- Order of execution FROM happens before WHERE thus inefficient

-- let's do the same thing in ANSI92
SELECT orderNumber, orders.customerNumber, customers.customerNumber, customerName
    FROM orders JOIN customers
    ON orders.customerNumber = customers.customerNumber;
    
-- Using the USING syntax    
SELECT orderNumber, customerNumber, customerName
    FROM orders JOIN customers
        USING (customerNumber);
        -- has to have two fields on both sides are identical
        -- same name (customerNumber==customerNumber)
        -- combines both fields

-- 4 different types of joins
-- show all customers and their orders, provide ordernumber, date and status
SELECT customerName, orderNumber, orderDate, status
    FROM customers JOIN orders USING(customerNumber)
    ORDER BY customerName;
    -- but we do not know if ALL the customers are listed, 
    -- because some might not have any orders
    
SELECT customerName, orderNumber, orderDate, status
    FROM customers LEFT OUTER JOIN orders 
        ON orders.customerNumber = customers.customerNumber
    ORDER BY customerName;
    -- LEFT OUTER JOIN
-- this shows ALL records from the table left of the keyword JOIN 
--     regardless if their is a match in the equality.

SELECT customerName, orderNumber, orderDate, status
    FROM orders RIGHT OUTER JOIN customers
        ON orders.customerNumber = customers.customerNumber
    ORDER BY customerName;
-- this statement is identical to the previous one, because the RIGHT OUTER 
-- will give ALL records from the table on the right of the keyword JOIN
    
-- so in the case where the table with the FK is the weighted side in the OUTER JOIN
-- there are no NULL records.
SELECT customerName, orderNumber, orderDate, status
    FROM orders LEFT OUTER JOIN customers
        ON orders.customerNumber = customers.customerNumber
    ORDER BY customerName;

-- LIST ONLY the customers whom do not have orders
SELECT customerName, orderNumber, orderDate, status
    FROM orders RIGHT OUTER JOIN customers
        ON orders.customerNumber = customers.customerNumber
    WHERE status IS NULL
    ORDER BY customerName;
    
-- by default the basic JOIN is an INNER JOIN, meaning INNER is optional
-- all LEFT and RIGHT joins are OUTER JOINS, meaning OUTER is optional
-- the 4th JOIN is FULL JOIN

SELECT customerName, orderNumber, orderDate, status
    FROM orders FULL OUTER JOIN customers
        ON orders.customerNumber = customers.customerNumber
    ORDER BY customerName;
    
-- Let us now do a query where we need MANY tables....
-- List the products that each customer has ordered.
SELECT DISTINCT c.customerNumber, customerName, p.productCode, productName
    FROM customers c JOIN orders ON orders.customerNumber = c.customerNumber
        JOIN orderDetails od ON orders.orderNumber = od.orderNumber
        JOIN products p ON od.productCode = p.productCode
    ORDER BY customerName;
    -- c and o are aliases for customers and orders

-- using distinct here
SELECT DISTINCT c.customerNumber, customerName, p.productCode, productName
    FROM customers c JOIN orders o ON o.customerNumber = c.customerNumber
        JOIN orderDetails od ON o.orderNumber = od.orderNumber
        JOIN products p ON od.productCode = p.productCode
    WHERE c.customerNumber = &custNumber
    ORDER BY customerName;
    
SELECT COUNT(*) FROM orderDetails;
    
-- so let's make sure we want ALL customers regardless if they have placed an order
SELECT DISTINCT c.customerNumber, customerName, p.productCode, productName
    FROM customers c LEFT OUTER JOIN orders o ON o.customerNumber = c.customerNumber
        LEFT OUTER JOIN orderDetails od ON o.orderNumber = od.orderNumber
        LEFT OUTER JOIN products p ON od.productCode = p.productCode
    ORDER BY customerName;
-- let's flip around the tables

SELECT DISTINCT customerNumber, customerName, productCode, productName
    FROM products p JOIN orderDetails od USING (productCode)
        JOIN orders o USING (orderNumber)
        RIGHT OUTER JOIN customers c USING (customerNumber)
    ORDER BY customerName;
    
    -- let us say we want ALL customers and ALL products
SELECT DISTINCT customerNumber, customerName, productCode, productName
    FROM products p LEFT OUTER JOIN orderDetails od USING (productCode)
        LEFT OUTER JOIN orders o USING (orderNumber)
        FULL  JOIN customers c USING (customerNumber)
    ORDER BY customerName;
    