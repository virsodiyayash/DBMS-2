----CREATE TABLE DEPARTMENT
CREATE TABLE Departments (
 DepartmentID INT PRIMARY KEY,
 DepartmentName VARCHAR(100) NOT NULL UNIQUE,
 ManagerID INT NOT NULL,
 Location VARCHAR(100) NOT NULL
);


----CREATE TABLE EMPLOYEE
CREATE TABLE Employee (
 EmployeeID INT PRIMARY KEY,
 FirstName VARCHAR(100) NOT NULL,
 LastName VARCHAR(100) NOT NULL,
 DoB DATETIME NOT NULL,
 Gender VARCHAR(50) NOT NULL,
 HireDate DATETIME NOT NULL,
 DepartmentID INT NOT NULL,
 Salary DECIMAL(10, 2) NOT NULL,
 FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);----CREATE TABLE PROJECTS
CREATE TABLE Projects (
 ProjectID INT PRIMARY KEY,
 ProjectName VARCHAR(100) NOT NULL,
 StartDate DATETIME NOT NULL,
 EndDate DATETIME NOT NULL,
 DepartmentID INT NOT NULL,
 FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);----INSERT VALUES INTO DEPARTMENTINSERT INTO Departments (DepartmentID, DepartmentName, ManagerID, Location)
VALUES
 (1, 'IT', 101, 'New York'),
 (2, 'HR', 102, 'San Francisco'),
 (3, 'Finance', 103, 'Los Angeles'),
 (4, 'Admin', 104, 'Chicago'),
 (5, 'Marketing', 105, 'Miami');



----INSERT VALUES INTO EMPLOYEE
INSERT INTO Employee (EmployeeID, FirstName, LastName, DoB, Gender, HireDate, DepartmentID,
Salary)
VALUES
 (101, 'John', 'Doe', '1985-04-12', 'Male', '2010-06-15', 1, 75000.00),
 (102, 'Jane', 'Smith', '1990-08-24', 'Female', '2015-03-10', 2, 60000.00),
 (103, 'Robert', 'Brown', '1982-12-05', 'Male', '2008-09-25', 3, 82000.00),
 (104, 'Emily', 'Davis', '1988-11-11', 'Female', '2012-07-18', 4, 58000.00),
 (105, 'Michael', 'Wilson', '1992-02-02', 'Male', '2018-11-30', 5, 67000.00);----INSERT VALUES INTO PROJECTSINSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate, DepartmentID)
VALUES
 (201, 'Project Alpha', '2022-01-01', '2022-12-31', 1),
 (202, 'Project Beta', '2023-03-15', '2024-03-14', 2),
 (203, 'Project Gamma', '2021-06-01', '2022-05-31', 3),
 (204, 'Project Delta', '2020-10-10', '2021-10-09', 4),
 (205, 'Project Epsilon', '2024-04-01', '2025-03-31', 5);



--------------------------PART-A----------------------------
--1. Create Stored Procedure for Employee table As User enters either First Name or Last Name and based on this you must give EmployeeID, DOB, Gender & Hiredate.

CREATE OR ALTER PROCEDURE PR_EMPLOYEE_DETAIL
@FIRSTNAME VARCHAR(50) = NULL,
@LASTNAME VARCHAR(50) = NULL
AS
BEGIN
	SELECT EMPLOYEEID , DOB , GENDER , HIREDATE FROM EMPLOYEE
	WHERE FIRSTNAME = @FIRSTNAME OR LASTNAME = @LASTNAME
END

EXEC PR_EMPLOYEE_DETAIL 'JOHN'
EXEC PR_EMPLOYEE_DETAIL @LASTNAME = 'DOE'

--2. Create a Procedure that will accept Department Name and based on that gives employees list who belongs to that department. 

create or alter procedure pr_department_details
@deptname varchar(50)
as
begin
	select Departments.DepartmentName , Employee.FirstName
	from employee join Departments 
	on employee.DepartmentID = Departments.DepartmentID
	where DepartmentName = @deptname
end

exec pr_department_details 'hr'

--3. Create a Procedure that accepts Project Name & Department Name and based on that you must give all the project related details.

create or alter procedure pr_project_details
@projectname varchar(50),
@departmentname varchar(50)
as
begin
	select Departments.DepartmentName , Projects.ProjectName , projects.StartDate , Projects.EndDate
	from Projects join Departments
	on projects.DepartmentID = Departments.DepartmentID
	where Projects.ProjectName = @projectname and Departments.DepartmentName = @departmentname
end

exec pr_project_details 'PROJECT BETA' , 'HR' 

--4. Create a procedure that will accepts any integer and if salary is between provided integer, then those employee list comes in output.

create or alter procedure pr_employee_list
@frange int,
@lrange int
as
begin
	select * 
	from employee 
	where salary > @frange and Salary < @lrange
end

exec pr_employee_list 72000 , 85000

--5. Create a Procedure that will accepts a date and gives all the employees who all are hired on that date.

create or alter procedure pr_select_from_date
@date datetime
as
begin
	select * 
	from employee
	where HireDate = @date
end

exec pr_select_from_date '2015-03-10'





-------------------------------PART-B-------------------------

--6. Create a Procedure that accepts Gender’s first letter only and based on that employee details will be served.

CREATE OR ALTER PROCEDURE PR_EMPLOYEE_GENDER_DETAILS
@GENDER CHAR(1)
AS
BEGIN
	SELECT * FROM EMPLOYEE
	WHERE GENDER LIKE @GENDER + '%'
END

EXEC PR_EMPLOYEE_GENDER_DETAILS 'M'

--7. Create a Procedure that accepts First Name or Department Name as input and based on that employeedata will come.

CREATE OR ALTER PROCEDURE PR_EMPLOYEE_DATA_WITH_FIRSTNAME_AND_DEPARTMENTNAME
@FIRSTNAME VARCHAR(50) = NULL,
@DEPARTMENTNAME VARCHAR(50) = NULL
AS
BEGIN
	SELECT EMPLOYEE.*
	FROM EMPLOYEE JOIN Departments
	ON EMPLOYEE.DepartmentID = Departments.DepartmentID
	WHERE EMPLOYEE.FirstName = @FIRSTNAME AND Departments.DepartmentName = @DEPARTMENTNAME
END

EXEC PR_EMPLOYEE_DATA_WITH_FIRSTNAME_AND_DEPARTMENTNAME 'JOHN' , 'IT'


--8. Create a procedure that will accepts location, if user enters a location any characters, then he/she will get all the departments with all data. 

CREATE OR ALTER PROCEDURE PR_DEPARTMENT_ALL_DATA
@LOC VARCHAR(50)
AS
BEGIN
	SELECT * FROM Departments
	WHERE Location LIKE '%' + @LOC + '%'
END

EXEC PR_DEPARTMENT_ALL_DATA 'NEW YORK'




---------------------------------PART-C------------------------------------
--9. Create a procedure that will accepts From Date & To Date and based on that he/she will retrieve Project related data.

CREATE OR ALTER PROCEDURE PR_PROJECT_DATE
@FDATE DATETIME,
@LDATE DATETIME
AS
BEGIN
	SELECT * FROM Projects
	WHERE StartDate = @FDATE AND EndDate = @LDATE
END

EXEC PR_PROJECT_DATE '20220101' , '20221231'

--10. Create a procedure in which user will enter project name & location and based on that you must provide all data with Department Name, Manager Name with Project Name & Starting Ending Dates.

CREATE OR ALTER PROCEDURE PR_PROJECT_LOCATION_ALL_DETAILS
@PROJECTNAME VARCHAR(50),
@LOCATION VARCHAR(50)
AS
BEGIN
	SELECT Departments.DepartmentName , Departments.ManagerID , Projects.ProjectName , Projects.StartDate , Projects.EndDate
	FROM Departments JOIN Employee
	ON Departments.DepartmentID = Employee.DepartmentID
	JOIN Projects
	on Departments.DepartmentID = Projects.DepartmentID
	where Projects.ProjectName = @PROJECTNAME and Departments.Location = @LOCATION
end

exec PR_PROJECT_LOCATION_ALL_DETAILS 'project alpha' , 'new york'
	