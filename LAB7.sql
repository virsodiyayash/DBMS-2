-- Create the Customers table
CREATE TABLE Customers (
 Customer_id INT PRIMARY KEY,
 Customer_Name VARCHAR(250) NOT NULL,
 Email VARCHAR(50) UNIQUE
);


-- Create the Orders table
CREATE TABLE Orders (
 Order_id INT PRIMARY KEY,
 Customer_id INT,
 Order_date DATE NOT NULL,
 FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id)
);


--------------------------Part – A---------------------------------
--1. Handle Divide by Zero Error and Print message like: Error occurs that is - Divide by zero error.

BEGIN TRY
	DECLARE @NUM1 INT = 10 , @NUM2 INT = 0 , @RESULT INT;
	SET @RESULT = @NUM1 / @NUM2
END TRY
BEGIN CATCH
	PRINT 'ERROR OCCURS THAT IS - DIVIDE BY ZERO ERROR';
END CATCH

--2. Try to convert string to integer and handle the error using try…catch block.

BEGIN TRY
	DECLARE @STR VARCHAR
	SET @STR = 'ABC'
	PRINT CAST(@STR AS INT)
END TRY
BEGIN CATCH
	PRINT 'STRING IS NOT CONVERT INTO INTEGER'
END CATCH


--3. Create a procedure that prints the sum of two numbers: take both numbers as integer & handle
--exception with all error functions if any one enters string value in numbers otherwise print result.

CREATE OR ALTER PROCEDURE PR_SUM
@FIRST VARCHAR(50) , @SECOND VARCHAR(50)
AS BEGIN
	BEGIN TRY
		DECLARE @FIRSTINT INT = CAST(@FIRST AS INT)
		DECLARE @SECONDINT INT = CAST(@SECOND AS INT)

		PRINT 'SUM IS : ' + CAST(@FIRSTINT + @SECONDINT AS VARCHAR(50));
	END TRY
	BEGIN CATCH
		SELECT ERROR_LINE() , ERROR_MESSAGE() , ERROR_NUMBER() , ERROR_PROCEDURE() , ERROR_SEVERITY() 
	END CATCH
END

EXEC PR_SUM '1' , 'ABC'

--4. Handle a Primary Key Violation while inserting data into customers table and print the error details
--such as the error message, error number, severity, and state.

BEGIN TRY
	INSERT INTO Customers VALUES(1 , 'MEET' , 'MEET@GMAIL.COM')
END TRY
BEGIN CATCH
	SELECT ERROR_LINE() , ERROR_MESSAGE() , ERROR_NUMBER() , ERROR_SEVERITY()
END CATCH

--5. Throw custom exception using stored procedure which accepts Customer_id as input & that throws
--Error like no Customer_id is available in database.

CREATE OR ALTER PROCEDURE PR_CUSTOMERS_CHECKCUSTOMERID
	@CUSTID INT
AS BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM Customers WHERE Customer_id = @CUSTID)
		BEGIN
			THROW 50001 , 'NO CUSTOMER_ID AVAILABLE IN CUSTOMER TABLE' , 1;
		END
		ELSE
		BEGIN
			PRINT 'CUSTOMER ID EXISTS'
		END
	END TRY
	BEGIN CATCH
		SELECT ERROR_LINE() , ERROR_MESSAGE() , ERROR_NUMBER() , ERROR_PROCEDURE() , ERROR_SEVERITY()
	END CATCH
END

EXEC PR_CUSTOMERS_CHECKCUSTOMERID 2;

--Part – B
--6. Handle a Foreign Key Violation while inserting data into Orders table and print appropriate error
--message.

BEGIN TRY
	INSERT INTO Orders VALUES(1 , 2 , '2001/12/12');
END TRY
BEGIN CATCH
	SELECT ERROR_LINE() , ERROR_MESSAGE() , ERROR_NUMBER() , ERROR_SEVERITY()
END CATCH

--7. Throw custom exception that throws error if the data is invalid.

CREATE OR ALTER PROCEDURE PR_CHECK_DATA_VALID
@AGE INT
AS
BEGIN
	BEGIN TRY
		IF(@AGE < 18)
			THROW 50002 , 'CAN NOT VOTE' , 1;
		ELSE
			PRINT 'YOU ARE ELIGIBLE'
	END TRY
	BEGIN CATCH
		SELECT ERROR_LINE() , ERROR_MESSAGE() , ERROR_PROCEDURE() , ERROR_NUMBER() , ERROR_SEVERITY()
	END CATCH
END

EXEC PR_CHECK_DATA_VALID 15
		

--8. Create a Procedure to Update Customer’s Email with Error Handling



--Part – C
--9. Create a procedure which prints the error message that “The Customer_id is already taken. Try another
--one”.



--10. Handle Duplicate Email Insertion in Customers Table.