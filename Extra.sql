--EmployeeDetails Table--

CREATE TABLE EMPLOYEEDETAILS
(
	EmployeeID Int Primary Key,
	EmployeeName Varchar(100) Not Null,
	ContactNo Varchar(100) Not Null,
	Department Varchar(100) Not Null,
	Salary Decimal(10,2) Not Null,
	JoiningDate DateTime Null
)


--EmployeeLog Table--

CREATE TABLE EmployeeLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    EmployeeName VARCHAR(100) NOT NULL,
    ActionPerformed VARCHAR(100) NOT NULL,
    ActionDate DATETIME NOT NULL
);



--1)	Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to display the message "Employee record inserted",
--"Employee record updated", "Employee record deleted"

CREATE OR ALTER TRIGGER TR_EMPLOYEE_RECORD_INSERT
ON EMPLOYEEDETAILS
AFTER INSERT
AS
BEGIN
	PRINT 'Employee record inserted'
END



CREATE OR ALTER TRIGGER TR_EMPLOYEE_RECORD_UPDATE
ON EMPLOYEEDETAILS
AFTER UPDATE
AS
BEGIN
	PRINT 'Employee record updated'
END


CREATE OR ALTER TRIGGER TR_EMPLOYEE_RECORD_DELETE
ON EMPLOYEEDETAILS
AFTER DELETE
AS
BEGIN
	PRINT 'Employee record deleted'
END

--2)	Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to log all operations into the EmployeeLog table.

CREATE OR ALTER TRIGGER TR_EMPLOYEELOG_INSERT
ON EmployeeLogs
AFTER INSERT
AS
BEGIN
	DECLARE @EmployeeID INT
	DECLARE @EMPLOYEENAME VARCHAR(50)

	SELECT @EmployeeID = EmployeeID FROM inserted
	SELECT @EMPLOYEENAME = Employeename from inserted

	insert into EmployeeLogs values(@EmployeeID , @EMPLOYEENAME , 'INSERT' , GETDATE())
END




CREATE OR ALTER TRIGGER TR_EMPLOYEELOG_UPDATE
ON EmployeeLogs
AFTER UPDATE
AS
BEGIN
	DECLARE @EmployeeID INT
	DECLARE @EMPLOYEENAME VARCHAR(50)

	SELECT @EmployeeID = EmployeeID FROM inserted
	SELECT @EMPLOYEENAME = Employeename from inserted

	insert into EmployeeLogs values(@EmployeeID , @EMPLOYEENAME , 'UPDATE' , GETDATE())
END




CREATE OR ALTER TRIGGER TR_EMPLOYEELOG_DELETE
ON EmployeeLogs
AFTER DELETE
AS
BEGIN
	DECLARE @EmployeeID INT
	DECLARE @EMPLOYEENAME VARCHAR(50)

	SELECT @EmployeeID = EmployeeID FROM inserted
	SELECT @EMPLOYEENAME = Employeename from inserted

	insert into EmployeeLogs values(@EmployeeID , @EMPLOYEENAME , 'DELETE' , GETDATE())
END

--3)	Create a trigger that fires AFTER INSERT to automatically calculate the joining bonus (10% of the salary) for new employees and update a bonus column in the EmployeeDetails table.


CREATE OR ALTER TRIGGER TR_EMPLOYEE_INSERT_DECREASE_SALARY
ON PERSONINFO
AFTER INSERT
AS
BEGIN
	DECLARE @OLDSALARY DECIMAL(8 , 2) , @NEWSALARY DECIMAL(8 , 2) , @PID INT

	SELECT @OLDSALARY FROM DELETED
	SELECT @NEWSALARY = SALARY , @PID = PERSONID FROM INSERTED

	IF @NEWSALARY < @OLDSALARY * 0.9
	BEGIN
		UPDATE PERSONINFO
		SET SALARY = @OLDSALARY
		WHERE PERSONID = @PID
	END
END


--4)	Create a trigger to ensure that the JoiningDate is automatically set to the current date if it is NULL during an INSERT operation.

--5)	Create a trigger that ensure that ContactNo is valid during insert and update (Like ContactNo length is 10)


