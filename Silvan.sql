-- Frederik Hvid Sørensen

-- 0.1 Opret Silvan database
CREATE DATABASE Silvan;

-- 0.2 Opret tabeller i databasen
USE Silvan;

	/* CUSTOMER */
CREATE TABLE customer(CustNo INTEGER PRIMARY KEY,
		      CustName VARCHAR(255),
		      State VARCHAR(2),
	      	      Phone VARCHAR(12));

	/* ITEM */
CREATE TABLE item(ItemNo INTEGER PRIMARY KEY,
		  ItemName VARCHAR(255),
		  ItemPrice MONEY,
		  QtyOnHand INTEGER);

	/* INVOICE */
CREATE TABLE invoice(InvNo INTEGER PRIMARY KEY,
		     InvDate DATE,
		     CustNo INTEGER FOREIGN KEY REFERENCES customer(CustNo));

	/* INVITEM */
CREATE TABLE invitem(InvNo INTEGER FOREIGN KEY REFERENCES invoice(InvNo),
		     ItemNo INTEGER FOREIGN KEY REFERENCES item(ItemNo),
		     Qty INTEGER);

-- 0.3 Opret database og tabeller med testdata fra opgaven
INSERT INTO customer VALUES (211, 'Garcia', 'NJ', '732-555-1000');
INSERT INTO customer VALUES (212, 'Parikh', 'NY', '212-555-2000');
INSERT INTO customer VALUES (225, 'Elsenhauer', 'NJ', '973-555-3333');
INSERT INTO customer VALUES (239, 'Bayer', 'FL', '407-555-7777');

INSERT INTO item VALUES (1, 'Screw', $2.25, 50);
INSERT INTO item VALUES (2, 'Nut', $5.00, 110);
INSERT INTO item VALUES (3, 'Bolt', $3.99, 75);
INSERT INTO item VALUES (4, 'Hammer', $9.99, 125);
INSERT INTO item VALUES (5, 'Washer', $1.99, 100);
INSERT INTO item VALUES (6, 'Nail', $0.99, 300);

INSERT INTO invoice VALUES (1001, '2000-09-05', 212);
INSERT INTO invoice VALUES (1002, '2000-09-17', 225);
INSERT INTO invoice VALUES (1003, '2000-09-17', 239);
INSERT INTO invoice VALUES (1004, '2000-09-18', 211);
INSERT INTO invoice VALUES (1005, '2000-09-21', 212);

INSERT INTO invitem VALUES (1001, 1, 5);
INSERT INTO invitem VALUES (1001, 3, 5);
INSERT INTO invitem VALUES (1001, 5, 9);
INSERT INTO invitem VALUES (1002, 1, 2);
INSERT INTO invitem VALUES (1002, 2, 3);
INSERT INTO invitem VALUES (1003, 1, 7);
INSERT INTO invitem VALUES (1003, 2, 5);
INSERT INTO invitem VALUES (1004, 4, 5);
INSERT INTO invitem VALUES (1005, 4, 10);

/* 
Brugt til at bevise, at alt er oprettet korrekt

SELECT * FROM customer;
SELECT * FROM item;
SELECT * FROM invoice;
SELECT * FROM invitem;
*/

-- OPG 1 - DISPLAY ALL CUSTOMER INFORMATION
SELECT * FROM customer;

-- OPG 2 - DISPLAY ALL ITEM NAMES AND THEIR RESPECTIVE UNIT PRICE
SELECT ItemName, ItemPrice FROM item;

-- OPG 3 - DISPLAY UNIQUE INVOICE NUMBERS FROM THE INVITEM TABLE
SELECT InvNo FROM invitem;

-- OPG 4 - DISPLAY ITEM INFORMATION WITH APPROPRIATE COLUMN ALIASES
SELECT ItemNo AS "Item number", ItemName AS "Name of item", ItemPrice AS "Unit price", QtyOnHand AS "Quantity on hand" FROM item;

-- OPG 5 - DISPLAY ITEM NAME AND PRICE IN SENTENCE FORM USING CONCATENATION
SELECT CONCAT(ItemName, ': ', FORMAT(ItemPrice, 'c', 'en-us')) AS "Listings" FROM item;

-- OPG 6 - FIND TOTAL VALUE OF EACH ITEM BASED ON QUANTITY ON HAND
SELECT ItemName, SUM(ItemPrice * QtyOnHand) AS "Total value" FROM item GROUP BY ItemName;

-- OPG 7 - FIND CUSTOMERS WHO ARE FROM THE STATE OF FLORIDA
SELECT * FROM customer WHERE State = 'FL';

-- OPG 8 - DISPLAY ITEMS WITH UNIT PRICE OF AT LEAST $5
SELECT * FROM item WHERE ItemPrice >= 5;

-- OPG 9 - WHICH ITEMS ARE BETWEEN $2 AND $57
SELECT * FROM item WHERE ItemPrice >= 2 AND ItemPrice <= 7;

-- OPG 10 - WHICH CUSTOMERS ARE FROM THE TRISTATE AREA OF NJ, NY, AND CT
SELECT * FROM customer WHERE State IN ('NJ', 'NY', 'CT');

-- OPG 11 - FIND ALL CUSTOMERS WHOSE NAMES START WITH THE LETTER E
SELECT * FROM customer WHERE CustName LIKE 'E%' OR CustName LIKE 'e%'; -- Tjekker store og små bogstaver for en sikkerheds skyld

-- OPG 12 - FIND ITEMS WITH E W IN THEIR NAME
SELECT * FROM item 
	WHERE (ItemName LIKE '%E%' OR ItemName LIKE '%e%') AND
		  (ItemName LIKE '%W%' OR ItemName LIKE '%w%');

-- OPG 13 - SORT ALL CUSTOMERS ALPHABETICALLY
SELECT * FROM customer ORDER BY CustName;

-- OPG 14 - SORT ALL ITEMS IN DESCENDING ORDER BY THEIR PRICE
SELECT * FROM item ORDER BY ItemPrice DESC;

-- OPG 15 - SORT ALL CUSTOMERS BY THEIR STATE AND ALSO ALPHABETICALLY BY NAME
SELECT * FROM customer ORDER BY State, CustName;

-- OPG 16 - DISPLAY ALL THE CUSTOMERS FROM NEW JERSEY ALPHABETICALLY
SELECT * FROM customer WHERE State = 'NJ' ORDER BY CustName;

-- OPG 17 - DISPLAY ALL ITEM PRICES ROUNDED TO THE NEAREST DOLLAR
SELECT ItemName, ROUND(ItemPrice,0) AS "Rounded item price" FROM item;

-- OPG 18 - THE PAYMENT IS DUE IN TWO MONTHS FROM THE INVOICE DATE. FIND THE PAYMENT DUE DATE
SELECT InvNo, CustNo, InvDate, DATEADD(month, 2, InvDate) AS "Payment due" FROM invoice;

-- OPG 19 - DISPLAY INVOICE DATES IN 'SEPTEMBER 05, 2000' FORMAT
SELECT InvNo, UPPER(FORMAT(InvDate, 'MMMM dd, yyyy')) AS "Dato" FROM invoice;

-- OPG 20 - FIND THE TOTAL, AVERAGE, HIGHEST, AND LOWEST UNIT PRICE IN ITEM
SELECT SUM(ItemPrice) AS "Sum of all prices", AVG(ItemPrice) AS "Average item price", MAX(ItemPrice) AS "Most expensive item", MIN(ItemPrice) AS "Least expensive item" FROM item;

-- OPG 21 - HOW MANY DIFFERENT ITEMS ARE AVAILABLE FOR CUSTOMERST
SELECT COUNT(*) AS "Unique items" FROM item;

-- OPG 22 - COUNT THE NUMBER OF ITEMS ORDERED IN EACH INVOICE
SELECT InvNo, COUNT(*) AS "Items ordered" FROM invitem GROUP BY InvNo;

-- OPG 23 - FIND INVOICES IN WHICH THREE OR MORE ITEMS ARE ORDERED
SELECT InvNo, COUNT(*) AS "Items ordered" FROM invitem GROUP BY InvNo HAVING COUNT(*) >= 3;

-- OPG 24 - FIND ALL POSSIBLE COMBINATIONS OF CUSTOMERS AND ITEMS (CARTESIAN PRODUCT)
SELECT * FROM customer CROSS JOIN item;

-- OPG 25 - DISPLAY ALL ITEM QUANTITIES AND ITEM PRICES FOR INVOICES
SELECT 
	invitem.InvNo AS "Invoice Number", 
	invitem.Qty AS "Quantity",
	FORMAT(item.ItemPrice, 'c', 'en-us') AS "Unit price",
	FORMAT(item.ItemPrice * invitem.Qty, 'c', 'en-us') AS "Total price"
FROM invitem
LEFT JOIN item ON item.ItemNo = invitem.ItemNo;

-- OPG 26 - FIND THE TOTAL PRICE AMOUNT FOR EACH INVOICE
SELECT InvNo, SUM(Qty * item.ItemPrice) AS "Total price" FROM invitem
LEFT JOIN item ON item.ItemNo = invitem.ItemNo
GROUP BY InvNo;

-- OPG 27 - USE AN OUTER JOIN TO DISPLAY ITEMS ORDERED AS WELL AS NOT ORDERED SO FAR
SELECT item.ItemName, 
	CASE 
		WHEN SUM(invitem.Qty) IS NULL THEN 0
		ELSE SUM(invitem.Qty) 
	END
		AS "Items sold", 
	CASE 
		WHEN SUM(item.QtyOnHand - invitem.Qty) IS NULL THEN SUM(item.QtyOnHand) 
		ELSE SUM(item.QtyOnHand - invitem.Qty) 
	END 
		AS "Items not sold" FROM item
LEFT JOIN invitem ON invitem.ItemNo = item.ItemNo GROUP BY item.ItemName;

-- OPG 28 - DISPLAY INVOICES. CUSTOMER NAMES, AND ITEM NAMES TOGETHER (MULTIPLE JOINS)
-- (THE JOIN OF FOUR TABLES MIGHT NOT RETURN ANY ROWS)
SELECT invoice.InvNo, customer.CustName, item.ItemName FROM invoice
JOIN customer ON invoice.CustNo = customer.CustNo
JOIN invitem ON invitem.InvNo = invoice.InvNo
JOIN item ON item.ItemNo = invitem.ItemNo;

-- OPG 29 - FIND INVOICES WITH HAMMER AS AN ITEM
SELECT invitem.InvNo, item.ItemName, invitem.Qty FROM invitem
JOIN item ON invitem.ItemNo = item.ItemNo
WHERE item.ItemName LIKE '%Hammer%';

-- OPG 30 - FIND INVOICES WITH HAMMER AS AN ITEM BY USING A SUB-QUERY INSTEAD OF A JOIN
SELECT
	InvNo, 
	(SELECT ItemName FROM item WHERE ItemName LIKE '%Hammer%') AS ItemName, 
	Qty FROM invitem
WHERE invitem.ItemNo = (SELECT ItemNo FROM item WHERE ItemName LIKE '%Hammer%');

-- OPG 31 - DISPLAY THE NAMES OF ITEMS ORDERED IN INVOICE NUMBER 1001 (USE A SUB-QUERY)
SELECT item.ItemName FROM item 
WHERE item.ItemNo IN 
	(SELECT invitem.ItemNo FROM invitem 
	 WHERE invitem.InvNo = 1001);

-- OPG 32 - FIND ITEMS THAT ARE CHEAPER THAN NUT
SELECT item.ItemName, item.ItemPrice FROM item 
WHERE item.ItemPrice < 
	(SELECT item.ItemPrice FROM item 
	 WHERE item.ItemName LIKE '%Nut%');

-- OPG 33 - CREATE A TABLE FOR ALL THE NEW JERSEY CUSTOMERS BASED ON THE EXISTING 
-- CUSTOMER TABLE
SELECT * INTO customer_nj FROM customer WHERE customer.State = 'NJ';

/*
Bevis at tabellen er korrekt oprettet

SELECT * FROM customer_nj
*/

-- OPG 34 - COPY ALL NEW YORK CUSTOMERS TO THE TABLE WITH NEW JERSEY CUSTOMERS
INSERT INTO customer_nj SELECT * FROM customer WHERE customer.State = 'NY';

/*
Bevis at tabellen er korrekt opdateret

SELECT * FROM customer_nj
*/

-- OPG 35 RENAME THE NJ CUSTOMER TABLE TO NYNJ CUSTOMER
EXEC sp_rename 'Silvan.dbo.customer_nj', 'NYNJ CUSTOMER';

/*
Bevis at tabellen er korrekt opdateret

SELECT * FROM [NYNJ CUSTOMER]
*/

-- OPG 36 - FIND CUSTOMERS WHO ARE IN CUSTEMER BUT NOT FROM NY OR NJ (USE SET OPERATOR MINUS)
SELECT * FROM customer EXCEPT SELECT * FROM customer WHERE State LIKE 'NY' OR State LIKE 'NJ';

-- OPG 37 - DELETE ROWS FROM THE CUSTOMER TABLE THAT ARE ALSO IN THE NYNJ_CUSTOMER TABLE

DELETE FROM customer WHERE customer.CustNo IN (SELECT CustNo FROM [NYNJ CUSTOMER]); -- Det må jeg ikke. Customer bliver refereret til i en foreign key i invoice.

-- OPG 38 - FIND THE ITEMS WITH THE TOP THREE PRICES
SELECT TOP 3 item.ItemName, item.ItemPrice FROM item ORDER BY item.ItemPrice DESC;

-- OPG 39 - FIND TWO ITEMS WITH THE LOWEST QUANTITY ON HAND
SELECT TOP 2 item.ItemName, item.QtyOnHand FROM item ORDER BY item.QtyOnHand;

-- OPG 40 - CREATE A SIMPLE VIEW WITH ITEM NAMES AND ITEM PRICES ONLY
CREATE VIEW namesAndPrices AS SELECT item.ItemName, item.ItemPrice FROM item;
SELECT * FROM namesAndPrices;

-- OPG 40 - CREATE A VIEW THAT WILL DISPLAY INVOICE NUMBER AND CUSTOMER NAMES FOR al CUSTOMERS
CREATE VIEW namesAndInvoices AS 
	SELECT customer.CustName, invoice.InvNo FROM customer
	JOIN invoice ON customer.CustNo = invoice.CustNo;
SELECT * FROM namesAndInvoices ORDER BY CustName;

-- OPG 41 - CREATE AN INDEX FILE TO SPEED UP A SEARCH BASED ON CUSTOMER'S NAME
CREATE INDEX index_CustName ON customer (CustName);

-- OPG 42 - LOCK CUSTOMER BAYER'S RECORD TO UPDATE THE STATE AND THE PHONE NUMBER
BEGIN TRANSACTION
UPDATE customer WITH (ROWLOCK)
SET State = 'CA',
Phone = '111-222-9999'
WHERE CustName LIKE '%Bayer%';
COMMIT TRANSACTION;

-- OPG 43 - GIVE EVERYBODY SELECT AND INSERT RIGHTS ON YOUR ITEM TABLE
GRANT SELECT, INSERT ON item TO public;

-- OPG 44 - REVOKE THE INSERT OPTION ON THE ITEM TABLE FROM USER EVERYBODY
REVOKE INSERT ON item TO public;
