/*Day 3
1)Show customer number, customer name, state and credit limit 
from customers table for below conditions. 
Sort the results by highest to lowest values of creditLimit.
●	State should not contain null values
●	credit limit should be between 50000 and 100000 */
use classicmodels;
select customerNumber,customername,state,creditlimit
from customers
where state is not null
and creditLimit between 50000 and 100000
order by creditLimit desc;

/*2)Show the unique productline values 
containing the word cars at the end from products table.*/
select distinct productLine
from products
where productLine like '%cars';

/*Day 4
1)Show the orderNumber, status and comments from 
orders table for shipped status only. 
If some comments are having null values 
then show them as “-“.*/
select orderNumber,status,coalesce('_') as comments
from orders
where status = 'shipped';

/*2)Select employee number, first name, job title 
and job title abbreviation from employees table 
based on following conditions.
If job title is one among the below conditions, 
then job title abbreviation column should show 
below forms.
●	President then “P”
●	Sales Manager / Sale Manager then “SM”
●	Sales Rep then “SR”
●	Containing VP word then “VP”
*/
select employeeNumber,firstName,jobTitle,
case
	when jobtitle = 'President' then 'P'
	when jobtitle in ('Sales Manager' or 'Sale Manager') 
    then 'SM'
	when jobtitle = 'Sales Rep' then 'SR'
	when jobtitle like '%vp%' then 'VP'
	else jobtitle
end as jobtitleabbrevation
from employees;

/*Day 5:
1)For every year, find the minimum amount value 
from payments table.*/

select year(paymentdate) as payment_year, min(amount) min_pay
from payments
group by payment_year
order by payment_year;

/*2)For every year and every quarter, 
find the unique customers and total orders 
from orders table. Make sure to show the quarter as
Q1,Q2 etc.*/

select year (orderdate) as year,
concat('Q',Quarter(orderdate)) as Quarter,

count(distinct customerNumber ) as 'unique coustomers',
count(*) as totalorders
from orders
group by year,quarter
order by year,quarter;

/*3)Show the formatted amount in thousands unit 
(e.g. 500K, 465K etc.) 
for every month (e.g. Jan, Feb etc.) 
with filter on total amount as 500000 to 1000000. 
Sort the output by total amount in descending mode. 
[ Refer. Payments Table]*/

use classicmodels;
select 
date_format(paymentdate,'%b') as month,
concat(format(sum(amount)/1000,0),'k') as formattedamount
from payments
group by month
having sum(amount) between 500000 and 1000000
order by sum(amount) desc;
/*Day 6:

1)	Create a journey table with following fields and constraints.

●	Bus_ID (No null values)
●	Bus_Name (No null values)
●	Source_Station (No null values)
●	Destination (No null values)
●	Email (must not contain any duplicates) */
create table journey(
Bus_ID int Not null,
Bus_Name varchar(100) Not null,
Source_Station varchar(100) Not null,
Destination varchar(100) not null,
Email varchar(100) unique 
);
/*
2)	Create vendor table with following fields and constraints.
●	Vendor_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Email (must not contain any duplicates)
●	Country (If no data is available then it should be shown as “N/A”)
*/
create table vendor(
vendor_id int primary key,
vname varchar(20) not null,
email varchar(20) unique,
country varchar(20) default 'N/A');

desc table vendor;

/*
3)	Create movies table with following fields and constraints.
●	Movie_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Release_Year (If no data is available then it should be shown as “-”)
●	Cast (No null values)
●	Gender (Either Male/Female)
●	No_of_shows (Must be a positive number)
*/
create table movies(
movie_id int primary key,
m_name varchar(50) not null,
release_year varchar(50) default '_',
cast varchar(50) not null,
gender enum('male','female'),
no_of_shows int check(no_of_shows >= 0));
/*
4)	Create the following tables. Use auto increment wherever applicable
a. Product
✔	product_id - primary key
✔	product_name - cannot be null and only unique values are allowed
✔	description
✔	supplier_id - foreign key of supplier table

b. Suppliers
✔	supplier_id - primary key
✔	supplier_name
✔	location

c. Stock
✔	id - primary key
✔	product_id - foreign key of product table
✔	balance_stock

*/
create table Suppliers(
supplier_id int auto_increment primary key,
supplier_name varchar(50),
location varchar(50));

create table product(
product_id int auto_increment primary key,
product_name varchar(50) not null unique,
description text,
supplier_id int,
foreign key (supplier_id) references suppliers (supplier_id) );

CREATE TABLE Stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    balance_stock INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

/*Day 7
1)	Show employee number,
 Sales Person (combination of first and last names of employees), 
unique customers for each employee number 
and sort the data by highest to lowest unique customers.
Tables: Employees, Customers
*/
SELECT 
    employeeNumber,
    CONCAT(firstname, ' ',lastname) AS 'Sales_Person',
    COUNT(DISTINCT c.customer_id) AS Unique_Customers
FROM 
    Employees e
LEFT JOIN 
    Customers c ON e.employee_number = c.sales_person_id
GROUP BY 
    e.employee_number
ORDER BY 
    Unique_Customers DESC;
/*
2)	Show total quantities, total quantities in stock, 
left over quantities for each product and each customer. 
Sort the data by customer number.
Tables: Customers, Orders, Orderdetails, Products*/

SELECT
    Customers.CustomerNumber,
    Customers.CustomerName,
    Products.ProductCode,
    Products.ProductName,
    SUM(orderdetails.QuantityOrdered) AS 'Ordered qty',
    SUM(products.QuantityInStock) AS 'Total Inventory',
    SUM(products.QuantityInstock - Orderdetails.QuantityOrdered) AS 'Left Qty'
FROM
    Customers
inner JOIN
    Orders
    ON Customers.CustomerNumber = Orders.CustomerNumber
inner JOIN
    OrderDetails
    ON Orders.OrderNumber = OrderDetails.OrderNumber
inner JOIN
    Products
    ON OrderDetails.ProductCode = Products.ProductCode
GROUP BY
    Customers.CustomerNumber,
    Products.ProductCode
ORDER BY
    Customers.CustomerNumber asc;
    
/*
3)Create below tables and fields. 
(You can add the data as per your wish)

●	Laptop: (Laptop_Name)
●	Colours: (Colour_Name)
Perform cross join between the two tables 
and find number of rows.
*/
CREATE TABLE Laptop (
    Laptop_Name VARCHAR(50)
);

INSERT INTO Laptop (Laptop_Name) VALUES
('Dell'),
('HP'),
('Lenovo');

CREATE TABLE Colours (
    Colour_Name VARCHAR(20)
);

INSERT INTO Colours (Colour_Name) VALUES
('Red'),
('Blue'),
('Green');

SELECT Laptop_Name, Colour_Name
FROM Laptop
CROSS JOIN Colours;

SELECT COUNT(*) AS number_of_rows
FROM Laptop
CROSS JOIN Colours;

/*
4)	Create table project with below fields.
●	EmployeeID
●	FullName
●	Gender
●	ManagerID
Add below data into it.
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
Find out the names of employees and their related managers.
*/
CREATE TABLE Project (
    EmployeeID INT,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    ManagerID INT
);

INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);

SELECT p1.FullName AS Manager_Name, p2.FullName AS Employee_Name
FROM Project p1
LEFT JOIN Project p2 ON p1.EmployeeID = p2.ManagerID;
/*
Day 8
Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country
i) Alter the table by adding the primary key 
and auto increment to Facility_ID column.
ii) Add a new column city after name with data type 
as varchar which should not accept any null values.
*/
CREATE TABLE facility (
    Facility_ID INT NOT NULL,
    f_Name VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255),
    PRIMARY KEY (Facility_ID)
);

ALTER TABLE facility 
MODIFY COLUMN Facility_ID INT AUTO_INCREMENT;

ALTER TABLE facility 
ADD COLUMN city VARCHAR(255) NOT NULL AFTER f_Name;

/*Create table university with below fields.
●	ID
●	Name
Add the below data into it as it is.
INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
Remove the spaces from everywhere and update the column like Pune University etc.
*/
CREATE TABLE university (
    ID INT NOT NULL,
    Name VARCHAR(255),
    PRIMARY KEY (ID)
);

INSERT INTO university (ID, Name) 
VALUES 
    (1, "       Pune          University     "), 
    (2, "  Mumbai          University     "),
    (3, "     Delhi   University     "),
    (4, "Madras University"),
    (5, "Nagpur University");

UPDATE university 
SET Name = TRIM(BOTH ' ' FROM REGEXP_REPLACE(Name,'{1,}',' '))
WHERE id is not null ;

UPDATE university 
SET Name = TRIM(BOTH ' ' FROM REGEXP_REPLACE(Name,' +',' '))
WHERE ID IS NOT NULL;

/*Day 10
Create the view products status. 
Show year wise total products sold. 
Also find the percentage of total value for each year. 
The output should look as shown in below figure.*/

CREATE VIEW products_status AS
SELECT 
    YEAR(OrderDate) AS Year,
    CONCAT(
        ROUND(COUNT(quantityOrdered * priceEach)),
        '(',
        ROUND((SUM(quantityOrdered * priceEach) / SUM(SUM(quantityOrdered * priceEach)) 
        OVER ()) * 100),
        '%)'
    ) AS total_values
FROM 
    orders 
JOIN 
    orderdetails ON orders.orderNumber = orderdetails.orderNumber
GROUP BY 
    YEAR(OrderDate);

select *  from products_status;

/*Day 11
1)	Create a stored procedure GetCustomerLevel which takes input 
as customer number and gives the output as either Platinum, Gold or Silver 
as per below criteria.

Table: Customers

●	Platinum: creditLimit > 100000
●	Gold: creditLimit is between 25000 to 100000
●	Silver: creditLimit < 25000
*/
DELIMITER //

CREATE PROCEDURE GetCustomerLevel (IN customer_number INT)
BEGIN
    DECLARE credit_limit DECIMAL(10, 2);
    DECLARE customer_level VARCHAR(20);

    SELECT creditLimit INTO credit_limit FROM Customers 
    WHERE customerNumber = customer_number;

    IF credit_limit > 100000 THEN
        SET customer_level = 'Platinum';
        
    ELSEIF credit_limit BETWEEN 25000 AND 100000 THEN
        SET customer_level = 'Gold';
	
    ELSEIF credit_limit <25000 THEN
        SET customer_level = 'Silver';
    ELSE
        SET customer_level = 'out of range';
    END IF;

    SELECT customer_level AS Customer_Level;
END //

DELIMITER ;

call classicmodels.GetCustomerLevel(496);

/*2)Create a stored procedure Get_country_payments 
which takes in year and country as inputs and gives year wise, 
country wise total amount as an output. 
Format the total amount to nearest thousand unit (K)
Tables: Customers, Payments*/

DELIMITER //

CREATE PROCEDURE Get_country_payments (IN input_year INT, IN input_country VARCHAR(50))
BEGIN
    SELECT
    YEAR(paymentDate) AS Year,
           country,
           CONCAT(FORMAT(SUM(amount) / 1000, 0), 'K') AS Total_Amount
    FROM Payments
    inner JOIN Customers 
    ON Payments.customerNumber = Customers.customerNumber
    WHERE YEAR(paymentDate) = input_year AND Customers.country = input_country
    GROUP BY Year, country;
END //

DELIMITER ;

call classicmodels.Get_country_payments(2003, 'france');
/*Day 12
1) Calculate year wise, month name wise count of orders and year over year (YoY) 
percentage change. Format the YoY values in no decimals and show in % sign.
Table: Orders*/
SELECT 
    YEAR(orderDate) AS Year,
    MONTHNAME(orderDate) AS Month_Name,
    COUNT(*) AS Order_Count,
    CONCAT(FORMAT((COUNT(*) - lag_order_count) / lag_order_count * 100, 0), '%') AS YoY_Percentage_Change
FROM (
    SELECT 
        orderDate,
        COUNT(*) AS lag_order_count,
        LAG(COUNT(*)) OVER (ORDER BY YEAR(orderDate), MONTH(orderDate)) AS lag_order_count
    FROM 
        Orders
    GROUP BY 
        YEAR(orderDate), MONTH(orderDate)
) AS subquery
GROUP BY 
    YEAR(orderDate), MONTH(orderDate)
ORDER BY 
    YEAR(orderDate), MONTH(orderDate);



WITH x AS (
    SELECT 
        YEAR(orderDate) AS year,
        MONTHNAME(orderDate) AS month,
        COUNT(orderDate) AS total_orders
    FROM
        Orders
    GROUP BY 
        year, month
)
SELECT 
    year,
    month,
    total_orders AS 'total orders',
    CONCAT(
        ROUND(
            100 * (
                total_orders - lag(total_orders) OVER (ORDER BY year)
            ) / lag(total_orders) OVER (ORDER BY year),
            0
        ),
        '%'
    ) AS '% yoy changes'
FROM 
    x;
    
/*2)Create the table emp_udf with below fields.

●	Emp_ID
●	Name
●	DOB
Add the data as shown in below query.
INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), 
("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");

Create a user defined function calculate_age which returns the age in years 
and months (e.g. 30 years 5 months) by accepting DOB column as a parameter.*/
CREATE TABLE emp_udf (
    Emp_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50),
    DOB DATE
);

INSERT INTO emp_udf (Name, DOB)
VALUES 
    ("Piyush", "1990-03-30"),
    ("Aman", "1992-08-15"),
    ("Meena", "1998-07-28"),
    ("Ketan", "2000-11-21"),
    ("Sanjay", "1995-05-21");
    
DELIMITER //

CREATE FUNCTION calculate_age(dob DATE)
RETURNS VARCHAR(50)
deterministic
BEGIN
    DECLARE years INT;
    DECLARE months INT;
    DECLARE age VARCHAR(50);
    
    SET years = TIMESTAMPDIFF(YEAR, dob, CURDATE());
    SET months = TIMESTAMPDIFF(MONTH, dob, CURDATE()) % 12;
    
    SET age = CONCAT(years, ' years ', months, ' months');
    
    RETURN age;
END //

DELIMITER ;

SELECT Name, DOB, calculate_age(DOB) AS Age FROM emp_udf;

/*Day 13
1)	Display the customer numbers and customer names from customers table 
who have not placed any orders using subquery
Table: Customers, Orders*/
SELECT customerNumber, customerName
FROM Customers
WHERE NOT EXISTS (
    SELECT customerNumber
    FROM Orders
    WHERE Orders.customerNumber = Customers.customerNumber
);

/*2)Write a full outer join between customers and orders using union 
and get the customer number, customer name, count of orders 
for every customer.
Table: Customers, Orders*/

SELECT c.CustomerNumber, c.CustomerName, COUNT(o.CustomerNumber) AS OrderCount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerNumber = o.CustomerNumber
GROUP BY c.CustomerNumber, c.CustomerName

UNION

SELECT o.CustomerNumber, c.CustomerName, COUNT(o.CustomerNumber) AS OrderCount
FROM Orders o
RIGHT JOIN Customers c ON c.CustomerNumber = o.CustomerNumber
GROUP BY o.CustomerNumber, c.CustomerName;

/*3) Show the second highest quantity ordered value 
for each order number.
 Table: Orderdetails */

WITH RankedOrderDetails AS (
    SELECT
        orderNumber,
        quantityOrdered,
        RANK() OVER (PARTITION BY OrderNumber ORDER BY quantityOrdered DESC) 
        AS QuantityRank
    FROM Orderdetails
)

SELECT
    OrderNumber,
    MAX(quantityOrdered) AS SecondHighestQuantity
FROM RankedOrderDetails
WHERE QuantityRank = 2
GROUP BY OrderNumber;

/* 4) For each order number count the number of products 
and then find the min and max of the values among count of orders.
 Table: Orderdetails*/

WITH OrderProductCounts AS (
    SELECT OrderNumber, COUNT(*) AS ProductCount
    FROM Orderdetails
    GROUP BY OrderNumber
)

SELECT
    
    MAX(ProductCount) AS MaxProductCount,
    MIN(ProductCount) AS MinProductCount
FROM OrderProductCounts;

/*5) Find out how many product lines are there 
for which the buy price value is greater than the average of buy price value. 
Show the output as product line and its count. */

SELECT ProductLine, COUNT(*) AS LineCount
FROM Products
WHERE BuyPrice > (SELECT AVG(BuyPrice) FROM Products)
GROUP BY ProductLine;

/*Day 14
Create the table Emp_EH. Below are its fields.
●	EmpID (Primary Key)
●	EmpName
●	EmailAddress
Create a procedure to accept the values for the columns in Emp_EH. 
Handle the error using exception handling concept. 
Show the message as “Error occurred” in case of anything wrong.
 */
CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    EmailAddress VARCHAR(100)
);

DELIMITER //
DELIMITER $$

CREATE PROCEDURE InsertEmp_EH(
    IN p_EmpID INT,
    IN p_EmpName VARCHAR(50),
    IN p_EmailAddress VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Error occurred' AS Message;
    END;

    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    VALUES (p_EmpID, p_EmpName, p_EmailAddress);

    SELECT 'Data inserted successfully' AS Message;
END $$

DELIMITER ;

/* Day 15
Create the table Emp_BIT. Add below fields in it.
●	Name
●	Occupation
●	Working_date
●	Working_hours

Insert the data as shown in below query.
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
 
Create before insert trigger to make sure any new value of Working_hours, 
if it is negative, then it should be inserted as positive.
 */
 CREATE TABLE Emp_BIT (
    Name VARCHAR(50),
    Occupation VARCHAR(50),
    Working_date DATE,
    Working_hours INT
);

INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) VALUES
('Robin', 'Scientist', '2020-10-04', 12),
('Warner', 'Engineer', '2020-10-04', 10),
('Peter', 'Actor', '2020-10-04', 13),
('Marco', 'Doctor', '2020-10-04', 14),
('Brayden', 'Teacher', '2020-10-04', 12),
('Antonio', 'Business', '2020-10-04', 11);

DELIMITER $$

CREATE TRIGGER Before_Insert_Emp_BIT
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = -NEW.Working_hours;
    END IF;
END;
$$

DELIMITER ;






    
    

            
            

















































































































