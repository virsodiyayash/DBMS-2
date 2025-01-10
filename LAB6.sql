-- Create the Products table
CREATE TABLE Products (
 Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
);



-- Insert data into the Products table
INSERT INTO Products (Product_id, Product_Name, Price) VALUES
(1, 'Smartphone', 35000),
(2, 'Laptop', 65000),
(3, 'Headphones', 5500),
(4, 'Television', 85000),
(5, 'Gaming Console', 32000);



--From the above given tables perform the following queries:

--------------------------------Part - A----------------------------

--1. Create a cursor Product_Cursor to fetch all the rows from a products table.

DECLARE @PID INT , @PNAME VARCHAR(50) , @PRICE DECIMAL(10, 2)

DECLARE PRODUCT_FETCH_ALL CURSOR 
FOR SELECT * FROM Products

OPEN PRODUCT_FETCH_ALL

FETCH NEXT FROM PRODUCT_FETCH_ALL INTO @PID , @PNAME , @PRICE

WHILE @@FETCH_STATUS = 0
	BEGIN 
		PRINT @PID;
		PRINT @PNAME;
		PRINT @PRICE
		FETCH NEXT FROM PRODUCT_FETCH_ALL INTO @PID , @PNAME , @PRICE
	END

CLOSE PRODUCT_FETCH_ALL
DEALLOCATE PRODUCT_FETCH_ALL



--2. Create a cursor Product_Cursor_Fetch to fetch the records in form of ProductID_ProductName. (Example: 1_Smartphone)


DECLARE PRODUCT_CURSOR_FETCH CURSOR 
FOR SELECT CAST(Product_id AS varchar) + '_' + Product_Name AS PRODUCTINFO FROM Products

OPEN PRODUCT_CURSOR_FETCH

DECLARE @PINFO VARCHAR(200)

FETCH NEXT FROM PRODUCT_CURSOR_FETCH INTO @PINFO

WHILE @@FETCH_STATUS = 0
	BEGIN 
		PRINT @PINFO
		FETCH NEXT FROM PRODUCT_CURSOR_FETCH INTO @PINFO
	END

CLOSE PRODUCT_CURSOR_FETCH
DEALLOCATE PRODUCT_CURSOR_FETCH


--3. Create a Cursor to Find and Display Products Above Price 30,000.

DECLARE @PRID INT , @PRNAME VARCHAR(50) , @PRPRICE DECIMAL(10, 2)

DECLARE PRODUCT_FETCH_PRICE CURSOR 
FOR SELECT * FROM Products WHERE Price > 30000

OPEN PRODUCT_FETCH_PRICE

FETCH NEXT FROM PRODUCT_FETCH_PRICE INTO @PRID , @PRNAME , @PRPRICE

WHILE @@FETCH_STATUS = 0
	BEGIN 
		PRINT @PRID;
		PRINT @PRNAME;
		PRINT @PRPRICE
		FETCH NEXT FROM PRODUCT_FETCH_PRICE INTO @PRID , @PRNAME , @PRPRICE
	END

CLOSE PRODUCT_FETCH_PRICE
DEALLOCATE PRODUCT_FETCH_PRICE


--4. Create a cursor Product_CursorDelete that deletes all the data from the Products table.

DECLARE @PROD_ID AS INT

DECLARE PRODUCT_CURSOR_DELETE CURSOR
FOR SELECT Product_id FROM Products WHERE Product_id = Product_id

OPEN PRODUCT_CURSOR_DELETE

FETCH NEXT FROM PRODUCT_CURSOR_DELETE  INTO @PROD_ID

WHILE @@FETCH_STATUS = 0
	BEGIN 
		DELETE FROM Products WHERE Product_id = @PROD_ID
		FETCH NEXT FROM PRODUCT_CURSOR_DELETE  INTO @PROD_ID
	END

CLOSE PRODUCT_CURSOR_DELETE
DEALLOCATE PRODUCT_CURSOR_DELETE



------------------------------------Part – B-------------------------------
--5. Create a cursor Product_CursorUpdate that retrieves all the data from the products table and increases the price by 10%.

DECLARE @PRO_ID INT , @PROPRICE DECIMAL(10 , 2) , @PRONAME VARCHAR(50)

DECLARE PRODUCT_CURSOR_UPDATE CURSOR
FOR SELECT Product_id , PRICE , Product_Name FROM Products

OPEN PRODUCT_CURSOR_UPDATE

FETCH NEXT FROM PRODUCT_CURSOR_UPDATE  INTO @PRO_ID , @PROPRICE , @PRONAME

WHILE @@FETCH_STATUS = 0
	BEGIN 
		UPDATE Products
		SET Price = @PROPRICE * 1.10
		WHERE Product_id = @PRO_ID

		PRINT @PRO_ID;
		PRINT @PRONAME;
		PRINT @PROPRICE

		FETCH NEXT FROM PRODUCT_CURSOR_UPDATE  INTO @PRO_ID , @PROPRICE , @PRONAME
	END

SELECT * FROM Products

CLOSE PRODUCT_CURSOR_UPDATE
DEALLOCATE PRODUCT_CURSOR_UPDATE


--6. Create a Cursor to Rounds the price of each product to the nearest whole number.

DECLARE @PID INT , @P DECIMAL(10 , 2)
DECLARE CURSOR_ROUND CURSOR

FOR SELECT Product_id , price from Products

open CURSOR_ROUND

fetch next from CURSOR_ROUND into @pid , @p

while @@FETCH_STATUS = 0
	Begin 
		update Products
		set Price = ROUND(@p , 0)
		where Product_id = @PID

		fetch next from CURSOR_ROUND into @pid , @p
	end

close CURSOR_ROUND
deallocate CURSOR_ROUND

select * from Products

--Part – C
--7. Create a cursor to insert details of Products into the NewProducts table if the product is “Laptop”
--(Note: Create NewProducts table first with same fields as Products table)
--8. Create a Cursor to Archive High-Price Products in a New Table (ArchivedProducts), Moves products
--with a price above 50000 to an archive table, removing them from the original Products table.