#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <cstring>
#include <occi.h>

using oracle::occi::Environment;
using oracle::occi::Connection;
using namespace oracle::occi;
using namespace std;

struct Employee // struct to hold queried info
{
	int employeeNumber;
	char lastName[50];
	char firstName[50];
	char email[100];
	char phone[50];
	char extension[10];
	char reportsTo[100];
	char jobTitle[50];
	char city[50];
};

// Pause execution until user enters the enter key
void pauseExecution(void) {
	printf("<< ENTER key to Continue... >>");
	while (getchar() != '\n') {
		; // do nothing
	}
	putchar('\n');
}

int getInt(const char* prompt = nullptr) {//gets an integer from the user

	int value;
	bool invalidEntry = true;
	if (prompt != nullptr) //if there is a message, print it out
	{
		std::cout << prompt;
	}
	do {
		std::cin >> value;
		//checks for valid inputs
		if (std::cin.fail()) {
			std::cin.clear();
			std::cin.ignore(10000, '\n');
			std::cout << "Please enter a valid number: ";
		}
		//rejects input if there are characters after the integer
		else if (getchar() != '\n') {
			cout << "Enter only an integer, please try again: ";
			cin.clear();
			cin.ignore(1000, '\n');
		}
		else {//exits loop
			invalidEntry = false;
			//cout << endl;
		}
	} while (invalidEntry);
	return value;
}

// function for employee lookup
int findEmployee(Connection* conn, int employeeNumber, struct Employee* emp) {

	int found = 0;
	try
	{
		Statement* stmt = conn->createStatement();

		// set a sql statement
		stmt->setSQL("SELECT e.employeenumber, e.lastname, e.firstname, e.email, o.phone, "
			"e.extension, m.firstname || ' ' || m.lastname, e.jobtitle, o.city "
			"FROM employees e LEFT JOIN employees m ON m.employeeNumber = e.reportsto "
			"LEFT JOIN offices o ON e.officecode = o.officecode "
			"WHERE e.employeenumber = :1");

		stmt->setInt(1, employeeNumber); //allow user input to be used in the query
		ResultSet* rs = stmt->executeQuery(); //executes the sql statement

		if (rs->next()) {//if return true, store query in struct
			found = 1;
			emp->employeeNumber = rs->getInt(1);
			strcpy(emp->lastName, rs->getString(2).c_str());
			strcpy(emp->firstName, rs->getString(3).c_str());
			strcpy(emp->email, rs->getString(4).c_str());
			strcpy(emp->phone, rs->getString(5).c_str());
			strcpy(emp->extension, rs->getString(6).c_str());
			strcpy(emp->reportsTo, rs->getString(7).c_str());
			strcpy(emp->jobTitle, rs->getString(8).c_str());
			strcpy(emp->city, rs->getString(9).c_str());
		}

		conn->terminateStatement(stmt);
	}
	catch (SQLException& sqlExcp) //if there is an error, display message and return to menu
	{
		cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage() << endl;
	}
	return found;
}

// displays a selected employee
void displayEmployee(Connection* conn, struct Employee emp) {

	int employeeNumber = getInt("Enter an employee number: "); //prompt for employee number

	if (findEmployee(conn, employeeNumber, &emp)) { //if function returns 1 (true)
		// display the employee in the following format
		cout << endl;
		cout << "employeeNumber = " << emp.employeeNumber << endl;
		cout << "lastName = " << emp.lastName << endl;
		cout << "firstName = " << emp.firstName << endl;
		cout << "email = " << emp.email << endl;
		cout << "phone = " << emp.phone << endl;
		cout << "extension = " << emp.extension << endl;
		cout << "reportsTo = " << emp.reportsTo << endl;
		cout << "jobTitle = " << emp.jobTitle << endl;
		cout << "city = " << emp.city << endl << endl;
	}
	else {  // If query has no results, displays the message
		cout << "Employee " << employeeNumber << " does not exist." << endl << endl;
	}
}

// display all employees from query
void displayAllEmployees(Connection* conn) {
	
	try
	{
		cout.setf(ios::left);

		//create and run the SQL statement
		Statement* stmt = conn->createStatement();
		ResultSet* rs = stmt->executeQuery("SELECT e.employeenumber, e.firstname || ' ' || e.lastname, e.email, "
			"o.phone, e.extension, m.firstname || ' ' || m.lastname "
			"FROM employees e LEFT JOIN employees m ON m.employeeNumber = e.reportsto "
			"LEFT JOIN offices o ON e.officecode = o.officecode "
			"ORDER BY e.employeeNumber");

		if (!(rs->next())) { // If query has no results, displays the message
			cout << "There is no employees’ information to be displayed." << endl;
		}
		else { // Otherwise, displays the header 
			cout.width(7);
			cout << "E";
			cout.width(20);
			cout << "Employee Name";
			cout.width(34);
			cout << "Email";
			cout.width(18);
			cout << "Phone Number";
			cout.width(8);
			cout << "Ext";
			cout.width(8);
			cout << "Manager" << endl;
			cout.width(95);
			cout.fill('-');
			cout << "-" << endl;

			cout.fill(' ');
			do { // display the result
				cout.width(7);
				cout << rs->getInt(1);
				cout.width(20);
				cout << rs->getString(2);
				cout.width(34);
				cout << rs->getString(3);
				cout.width(18);
				cout << rs->getString(4);
				cout.width(8);
				cout << rs->getString(5);
				cout << rs->getString(6) << endl;
			} while (rs->next()); //while there are still records stored
		}
		cout << endl;
		conn->terminateStatement(stmt);
	}
	catch (SQLException& sqlExcp) //if there is an error, display message and return to menu
	{
		cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage() << endl;
	}
}

// Insert new employee information into employees table
void insertEmployee(Connection* conn, struct Employee emp) {

	try
	{
		int employeeNumber = getInt("Employee Number: ");
		// Ensure employee number doesn't already exist
		if (findEmployee(conn, employeeNumber, &emp)) {
			cout << "An employee with the same employee number exists." << endl << endl;
		}
		else {// prompts for each field and store it in the employee struct
			cout << "Last Name: ";
			cin.getline(emp.lastName, 50);
			cout << "First Name: ";
			cin.getline(emp.firstName, 50);
			cout << "Email: ";
			cin.getline(emp.email, 100);
			cout << "extension: ";
			cin.getline(emp.extension, 10);
			cout << "Job Title: ";
			cin.getline(emp.jobTitle, 50);
			cout << "City: ";
			cin.getline(emp.city, 50);
			Statement* stmt = conn->createStatement();
			stmt->setSQL("INSERT INTO employees "
				"VALUES (:1, :2, :3, :4, :5, :6, :7, :8)");
			stmt->setInt(1, employeeNumber);	// Values of the INSERT statement
			stmt->setString(2, emp.lastName);	// are the data from the employee object
			stmt->setString(3, emp.firstName);
			stmt->setString(4, emp.extension);
			stmt->setString(5, emp.email);
			stmt->setString(6, "1");
			stmt->setInt(7, 1002);
			stmt->setString(8, emp.jobTitle);

			// executeUpdate returns either the row count for INSERT, UPDATE or DELETE or 0
			if (stmt->executeUpdate()) {
				cout << "The new employee is added successfully." << endl << endl;
			}
			else {
				cout << "Failed to add new employee" << endl;
			}
			conn->terminateStatement(stmt);
		}
	}
	catch (SQLException& sqlExcp) //if there is an error, display message and return to menu
	{
		cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage() << endl;
	}
}

// Updates extension of an existing employee
void updateEmployee(Connection* conn, int employeeNumber) {
	try
	{
		Employee emp = {};
		char extension[10];
		if (findEmployee(conn, employeeNumber, &emp)) {
			Statement* stmt = conn->createStatement();
			cout << "New phone extension: ";
			cin.getline(extension, 10);
			stmt->setSQL("UPDATE employees "	// Setting DML statement
				"SET extension = :1"	// to update extension
				"WHERE employeeNumber = :2");
			stmt->setString(1, extension);
			stmt->setInt(2, employeeNumber);
			if (stmt->executeUpdate()) {	//If a row is updated, display message.
				cout << "Phone extension updated." << endl << endl;
			}
			conn->terminateStatement(stmt);
		}
		else {
			cout << "Employee " << employeeNumber << " does not exist." << endl << endl;
		}
	}
	catch (SQLException& sqlExcp) //if there is an error, display message and return to menu
	{
		cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage() << endl;
		cout << "Employee " << employeeNumber << " was NOT updated." << endl << endl;
	}
}

// Deletes an employee from the employees table using employee number
void deleteEmployee(Connection* conn, int employeeNumber) {
	Employee emp = {};
	try
	{
		if (findEmployee(conn, employeeNumber, &emp)) {	// 
			Statement* stmt = conn->createStatement();
			stmt->setSQL("DELETE FROM employees "	// Setting DML statement to delete
				"WHERE employeeNumber = :1");		// employee of a given employee number
			stmt->setInt(1, employeeNumber);

			if (stmt->executeUpdate()) {
				cout << "The employee is deleted." << endl << endl;
			}
			conn->terminateStatement(stmt);
		}
		else {
			cout << "Employee " << employeeNumber << " does not exist." << endl << endl;
		}
	}
	catch (SQLException& sqlExcp) //if there is an error, display message and return to menu (i.e. breaks ref integrity
	{
		cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
		cout << "Employee " << employeeNumber << " was NOT deleted." << endl << endl;
	}
}

int main() {
	// OCCI Variables
	Environment* env = nullptr;
	Connection* conn = nullptr;
	// User Login Variables
	string usr = "dbs211_212d23";
	string pass = "12450245";
	string srv = "myoracle12c.senecacollege.ca:1521/oracle12c";

	//initializing variables and class
	Employee emp = {};
	bool invalidOption = true;
	int menuOption = -1;
	int empNumber = 0; //Initialized an int employee number here
	try {
		//create SQL environment and connection to database
		env = Environment::createEnvironment(Environment::DEFAULT);
		conn = env->createConnection(usr, pass, srv);
		do {
			do {
				//display menu  
				std::cout << "********************* HR Menu *********************" << endl;
				std::cout << "1) Find Employee" << endl;
				std::cout << "2) Employees Report" << endl;
				std::cout << "3) Add Employee" << endl;
				std::cout << "4) Update Employee" << endl;
				std::cout << "5) Remove Employee" << endl;
				std::cout << "0) Exit" << endl;
				menuOption = getInt("Enter an option (0 - 5): ");
				if (menuOption < 0 || menuOption > 5) {
					std::cout << "Please enter a valid option." << endl << endl;
				}
				else {
					invalidOption = false;
				}
			} while (invalidOption);

			//calls function depending on user selection
			switch (menuOption) {
			case 1:
				cout << endl;
				displayEmployee(conn, emp);
				pauseExecution();
				break;
			case 2:
				cout << endl;
				displayAllEmployees(conn);
				pauseExecution();
				break;
			case 3:
				cout << endl;
				insertEmployee(conn, emp);
				pauseExecution();
				break;
			case 4:
				cout << endl;
				empNumber = getInt("Enter an employee number: ");
				updateEmployee(conn, empNumber);
				pauseExecution();
				break;
			case 5:
				cout << endl;
				empNumber = getInt("Enter an employee number: ");
				deleteEmployee(conn, empNumber);
				pauseExecution();
				break;
			case 0:
				cout << "Exiting" << endl;
				break;
			default:
				break;
			}
		} while (menuOption != 0);

		// terminate connection and environment
		env->terminateConnection(conn);
		Environment::terminateEnvironment(env);
	}
	catch (SQLException& sqlExcp) //display error message if could not connect to DBS (i.e. no internet connection)
	{
		cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
		cout << "Cound not connect to database, exiting" << endl;
	}
	return 0;	
}