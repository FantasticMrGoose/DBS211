-- Week 5: DDL - Creation, Constraints, Referential Integrity
-- DESCRIPTION: Intro to DDL and database creation scripts

-- CREATE TABLE SYNTAX
--CREATE TABLE tablename (
--    field1 datatype constraints,
--    field2 datatype constraints,
--    .....
--    fieldn datatype constraints,
--    CONSTRAINT constraintName constraintType constraintDetails,
      --can have several constraints
--);

/* 7 Constraints
1. Primary Key - Unique Identifier
2. Foreign Key - Child Reference - may have referential integrity
3. Unique - unique valies, no dulicates 
4. Required - required (NOT NULL)
5. Default - apply a value if a NULL is inserted
6. Range - CHECK - a range of acceptable values (like grade from 0 - 100)
7. Index - Field pre-sorted for quick search capabilities 
*/

--example - People table from ICE CREAM example
CREATE TABLE icPeople (
    personID NUMBER(5) PRIMARY KEY,
    --already unique and not null
    firstName VARCHAR(50) NOT NULL,
    -- good for bigger numbers
    -- varchar sets size to the longest variable, but specify limit
    -- CHAR: sets the exact size
    lastName VARCHAR(50) NOT NULL,
    phone CHAR(10),
    email VARCHAR(75) NOT NULL UNIQUE,
    DOB DATE,
    address VARCHAR(100),
    gender CHAR(1) CHECK (upper(gender) IN ('M', 'F', 'O')),
    YearOfBirth NUMBER(5) CHECK (YearOfBirth BETWEEN 1900 AND 2030)
);
    
-- another example ORDER TABLE
CREATE TABLE icOrder (
    orderID INT,
    orderDate DATE NOT NULL,
    isPaid NUMBER(3) DEFAULT(0), --pick either default or not null
    employeeID NUMBER(5),
    customerID NUMBER(5),
    CONSTRAINT icOrder_PK PRIMARY KEY(orderID), 
    -- creates names for the constraint so it can be altered later
    CONSTRAINT order_employee_FK 
        FOREIGN KEY (employeeID) REFERENCES icPeople(personID),
        -- your fk is in the table that is being created
    CONSTRAINT order_customer_FK 
        FOREIGN KEY (customerID) REFERENCES icPeople(personID),
    CONSTRAINT isPaid_CHK CHECK (isPaid BETWEEN 0 AND 1)
);

INSERT INTO icPeople VALUES (1, 'Clint', 'MacDonald', '9055551212', 
    'clint.macdonald@senecacollege.ca', NULL, NULL, 'M', 1972);
INSERT INTO icPeople VALUES (2, 'Bob', 'McKenzie', '9054891212', 
    'bob.mckenzie@senecacollege.ca', NULL, NULL, 'F', 2001);
    
INSERT INTO icOrder VALUES (1, sysdate, 1, 1, 2);

-- composite primary kets
CREATE TABLE icOrderItems (
    orderID INT,
    productID INT,
    flavourID NUMBER(5),
    quantity NUMBER(3) CHECK (quantity BETWEEN 1 AND 100),
    CONSTRAINT orderItems_PK PRIMARY KEY (orderID, productID, flavourID)
);

ALTER TABLE icOrderItems 
    ADD CONSTRAINT orderItems_order_FK FOREIGN KEY (orderID) 
        REFERENCES icOrder(orderID);
        
CREATE TABLE icProducts (
    productID NUMBER(5) PRIMARY KEY,
    productName VARCHAR(50) NOT NULL,
    productSize VARCHAR(15),
    price NUMBER(6,2) CHECK(price BETWEEN 0 AND 999.99)
);

CREATE TABLE icFlavours (
    flavourID NUMBER(3) primary key,
    flavour VARCHAR(25),
    surcharge NUMBER(6,2) DEFAULT(0),
    calories NUMBER(5) CHECK (calories BETWEEN 0 AND 10000),
    isActive NUMBER(3) CHECK (isActive BETWEEN 0 AND 1)
    );
    
ALTER TABLE icOrderItems 
    ADD CONSTRAINT orderItems_products_FK FOREIGN KEY (productID) 
        REFERENCES icProducts(productID);
        
ALTER TABLE icOrderItems 
    ADD CONSTRAINT orderItems_flavours_FK FOREIGN KEY (flavourID) 
        REFERENCES icFlavours(flavourID);
        
DROP TABLE icOrderItems CASCADE CONSTRAINTS; -- drops the constraints as well
ALTER TABLE icOrderItems DROP CONSTRAINT orderItems_products_FK;