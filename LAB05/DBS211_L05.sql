SET AUTOCOMMIT ON; 

-- PART A (DDL)
-- Question 1 
/* Create table the following tables and their given constraints */

CREATE TABLE l5_movies (
    mid INT PRIMARY KEY,
    title VARCHAR(35) NOT NULL,
    releaseYear INT NOT NULL,
    director INT NOT NULL,
    score NUMBER(3,2) CHECK(score BETWEEN 0 AND 5)
);

CREATE TABLE l5_actors (
    aid INT PRIMARY KEY,
    firstName VARCHAR(20) NOT NULL,
    lastName VARCHAR(30) NOT NULL
);

CREATE TABLE l5_casting (
    movieid INT,
    actorid INT, 
    CONSTRAINT casting_PK PRIMARY KEY(movieid, actorid),
    CONSTRAINT casting_movies_FK FOREIGN KEY (movieid) 
        REFERENCES l5_movies(mid),
    CONSTRAINT casting_actors_FK FOREIGN KEY (actorid)
        REFERENCES l5_actors(aid)
);

CREATE TABLE l5_directors (
    directorid INT PRIMARY KEY,
    firstName VARCHAR(20) NOT NULL,
    lastName VARCHAR(30) NOT NULL
);

-- Question 2
/* Modify the movies table to create a foreign key constraint that refers to 
table directors*/

ALTER TABLE l5_movies
    ADD CONSTRAINT movies_directors_FK FOREIGN KEY (director)
        REFERENCES l5_directors(directorid);
        
-- Question 3
/* Modify the movies table to create a new constraint so the uniqueness of the 
movie title is guaranteed*/

ALTER TABLE l5_movies 
    ADD CONSTRAINT nameUnique UNIQUE(title);
    
-- Question 4
/* Write insert statements to add the following data to table directors and 
movies*/

INSERT ALL
    INTO l5_directors(directorid, firstName, lastName) 
        VALUES(1010, 'Bob', 'Minkoff')
    INTO l5_directors(directorid, firstName, lastName) 
        VALUES(1020, 'Bill', 'Condon')
    INTO l5_directors(directorid, firstName, lastName) 
        VALUES(1050, 'Josh', 'Cooley')
    INTO l5_directors(directorid, firstName, lastName) 
        VALUES(2010, 'Brad', 'Bird')
    INTO l5_directors(directorid, firstName, lastName) 
        VALUES(3020, 'Lake', 'Bell')
    SELECT * FROM dual;

INSERT ALL
    INTO l5_movies(mid, title, releaseYear, director, score)
        VALUES(100, 'The Lion King', 2019, 3020, 3.50)
    INTO l5_movies(mid, title, releaseYear, director, score)
        VALUES(200, 'Beauty and the Beast', 2017, 1050, 4.20)
    INTO l5_movies(mid, title, releaseYear, director, score)
        VALUES(300, 'Toy Story 4', 2019, 1020, 4.50)
    INTO l5_movies(mid, title, releaseYear, director, score)
        VALUES(400, 'Mission Impossible', 2018, 2010, 5.00)
    INTO l5_movies(mid, title, releaseYear, director, score)
        VALUES(500, 'The Secret Life of Pets', 2016, 1010, 3.90)
    SELECT * FROM dual;

-- Question 5
/* Write SQL statementsto removeall above tables.Is the order of tables 
important when removing? Why? */

DROP TABLE l5_CASTING;
DROP TABLE l5_actors;
DROP TABLE l5_movies;
DROP TABLE l5_directors;
/* The order of tables being dropped is not important if the drop statement
uses cascading to drop constraints. The foreign key that is being used (in the
child table) to refer to the table being dropped (the parent table)
is removed as well, thus keeping referential integrity. 

However, if cascading is not used then the order is important as the foreign
key constraint trigger referential integrity preventing the table from
being removed (or removing both tables). Thus the table without foreign keys 
(parent table) must be removed first, in order to remove the child table.
(NO, the child table must be removed first)*/

-- PART B (More DML)

-- Question 6
/* Create a new empty table employee2 the sameas table employees. Use a single 
statement to create the table and insert the data at the same time */

CREATE TABLE employees2 AS SELECT * FROM employees;

ALTER TABLE employees2
    ADD (
    CONSTRAINT employees2_PK PRIMARY KEY(employeeNumber),
    CONSTRAINT employee_office_FK FOREIGN KEY(officeCode)
        REFERENCES offices(officeCode),
    CONSTRAINT emp_reportTo_FK FOREIGN KEY(reportsTo)
        REFERENCES employees2(employeeNumber)
);

-- Question 7
/* Modify table employee2and add a new column usernameto this table. 
The value of this column is not required and does not have to be unique */

ALTER TABLE employees2
    ADD username VARCHAR(20);

-- Question 8
/* Delete all the data in the employee2 table */

DELETE FROM employees2;

-- Question 9
/* Re-insert all data from the employees table into your new table 
employee2using a single statement.*/

INSERT INTO employees2(employeeNumber, lastName, firstName, extension, email,
           officeCode, reportsTo, jobTitle)
    SELECT * FROM employees;
    
-- Question 10
/* In table employee2, write a SQL statement to change the first name and 
the last name of employee with ID 1002to your name*/

UPDATE employees2
    SET firstName = 'Ziran Jeffrey',
        lastName = 'Zhou'
    WHERE employeeNumber = 1002;

-- Question 11
/* In table employee2, generate the email address for column username for each 
student by concatenating the first character of employee’s first name and the 
employee’s last name. For instance, the username of employee Peter Stone will be 
pstone. NOTE: the username is in all lower case letters.*/

UPDATE employees2
    SET username = LOWER(SUBSTR(firstname, 0,1) || lastname);

-- Question 12
/* In table employee2, remove all employees with office code 4 */

/* In order to remove all employees at office 4, we will either have to remove
the FK constraint, else referential integrity will trigger. Another option would
be to change the database to ensure that no one reports to employees in office 4
before we fire everyone there (or update where they are relocated to first).

The following method drops the constraints since this is a copy table*/

ALTER TABLE employees2
    DROP CONSTRAINT emp_reportTo_FK;
    
DELETE FROM employees2 WHERE officeCode = 4;

-- Question 13
/* Drop table employee2 */

DROP TABLE employees2;
