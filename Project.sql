DROP DATABASE IF EXISTS bookstore;

CREATE DATABASE bookstore;

USE bookstore;

-- I enforce requiremtns needed to be a customer which is stuff you need for an account
CREATE TABLE Customers(
	fname VARCHAR(20) NOT NULL,
    lname VARCHAR(20) NOT NULL,
    gender VARCHAR(1),
    bday VARCHAR(10),
    email VARCHAR(30) NOT NULL,
    address VARCHAR(50) NOT NULL,
    zipcode INT NOT NULL,
    phone_number_home VARCHAR(20) NULL,
    phone_number_cell VARCHAR(20),
    customer_id INT UNIQUE NOT NULL,
	username VARCHAR(20) UNIQUE NOT NULL,
    password VARCHAR(20) UNIQUE NOT NULL,
    PRIMARY KEY (customer_id)
);

INSERT INTO Customers(fname, lname, gender, bday, email, address, zipcode, phone_number_home, phone_number_cell, customer_id, username, password) VALUES
('Tom', 'Hunks', 'M', '12/1/1990', 'thunks@yahoo.com', '1100 Grand Road, New York, NY', 10001, '212-400-0001', '212-100-222', 00001, 'xxyy', '0808'),
('Tom', 'Cruise', 'M', '10/1/1991', 'tcruise@yahoo.com', '441 East Fordham Road, Bronx, NY', 10458, NULL, '718-817-3333', 00002, 'xzzz', '11223' ),
('Tina', 'Fei', 'F', '12/1/1956', 'tfei11@yah oo.com', '42 Fordham Road, Bronx, NY', 10458, '817-718-0001', '212-100-2234', 00003, 'abcd', 'xyz13'),
('Rice', 'Brown', 'F', '12/1/1970', 'rbrown1999@hotmail.com', '383 56th Street, New York, NY', 10002, NULL, '212-0001-7788', 00004, 'iama', '34ii'),
('Lisa', 'Warren', 'F', '12/1/1972', 'lisawarren@gmail.com', '1 Fordham Road, Bronx, NY', 10458, 212-300-7777, '212-300-1199', 00005, 'lisaw', '8877');


-- Some payment stuff can be null as not all customers with account buy items and thus have no payment methods
CREATE TABLE Payment_method(
	customer_id INT NOT NULL,
    payment_id INT NOT NULL,
    holder VARCHAR(50) NULL,
    card_number VARCHAR(50) NULL,
	bank_account_number VARCHAR(30) NULL,
    card_expiration VARCHAR(10) NULL,
    account_type VARCHAR(10) NULL,
    contact_number VARCHAR(20) NULL,
    bname VARCHAR(20) NULL,
    billing_address VARCHAR(50) NULL,
    -- Ensures there can be more than one payment method per customer
    PRIMARY KEY (payment_id),
    -- Ensures a customer is connected to a payment method
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
    ON UPDATE CASCADE
	ON DELETE NO ACTION
);

INSERT INTO Payment_method(customer_id, payment_id, holder, card_number, bank_account_number, card_expiration, contact_number, billing_address, bname, account_type) VALUES
(00001, 1, 'Tom Hunks', '9999 9999 8888 8888', 1112223, '08/17', '212-400-0001', '1100 Grand Road, New York, NY 10001', 'Chase', 'Checking'),
(00002, 2, 'Tom Cruise', '2222 4444 5555 6666', NULL, '12/14', '718-817-3333', '441 East Fordham Road, Bronx, NY 10458', NULL, 'Credit'),
(00003, 3, 'Tine Fei', '1234 1234 5678 5678', 12667, '10/18', '817-718-0001', '442 Fordham Road, Bronx, NY10458', 'Capital One', 'Checking'),
(00004, 4, 'Rice Brown', '1122 3344 5566 7788', NULL, '1/16', '212-0001-7788', '38 56th Street, New York, NY 10002', NULL, 'Credit'),
(00005, 5, 'Lisa Warren', '1111 2222 3333 4444', 9922882, '1/17', '212-300-1199', '1 Fordham Road, Bronx, NY 10458', 'Chase', 'Checking');

CREATE TABLE Genre(
	genre_id INT NOT NULL,
    ngenre VARCHAR(20) NOT NULL,
    PRIMARY KEY (genre_id)
);

INSERT INTO Genre(genre_id, ngenre) VALUES
(1, 'art'),
(2, 'science');

CREATE TABLE Books(
	ISBN VARCHAR(20) NOT NULL,
    title VARCHAR(80) NOT NULL,
    price FLOAT NOT NULL,
    edition INT NULL,
    year INT,
    publisher VARCHAR(50),
    author_id INT UNIQUE NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (ISBN),
    -- One to many as one genre can be associated with many books
    FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

INSERT INTO Books(ISBN, title, price, edition, year, publisher, author_id, genre_id) VALUES
('0-8053-1755-4', 'Fundamentals of Database Systems', 100.00, 3, 2000, 'Addison Wesley', 1, 2),
('978-0-12-374856-0', 'Data Mining, Practical Machine Learning Tools and Techniques', 120.00, 3, 2011, 'Elsevier', 2, 2),
('0-1153-2555-5', 'Writing Skills', 30.00, NULL, 2010, 'Elsevier', 3, 1),
('978-0-07-246563-1', 'Database Management Systems', 110.00, 3, 2003, 'McGraw-Hill', 4, 2);

CREATE TABLE Authors(
	author_id INT NOT NULL,
    nauthor VARCHAR(60) NOT NULL,
    PRIMARY KEY (author_id)
);

INSERT INTO Authors (author_id, nauthor) VALUES
(1, 'Ramez A. Elmasri and Shamkant Navathe'),
(2, 'Ian H. Witten, Eibe Frank, and Mark Hall'),
(3, 'Matt Florence'),
(4, 'Raghu Ramakrishnan and Johannes Gehrke');

CREATE TABLE Inventory(
	ISBN VARCHAR(20) NOT NULL,
    quantity_of_books INT NULL,
    PRIMARY KEY (ISBN),
    -- One to one as every ISBN is unique
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN)
    ON UPDATE CASCADE
	ON DELETE CASCADE
);

INSERT INTO Inventory(ISBN, quantity_of_books) VALUES
('0-8053-1755-4', 20),
('978-0-12-374856-0', 25),
('0-1153-2555-5', 10),
('978-0-07-246563-1', 15);

-- Junction table
CREATE TABLE Cart(
	order_num INT NOT NULL,
	customer_id INT NOT NULL,
    book_id VARCHAR(20) NOT NULL,
    quantity INT,
    -- Outputs the total price which can be calculated in a query
    total_price float,
    payment INT,
    cart_date VARCHAR(10),
    -- Many customers can have multiple orders 
    PRIMARY KEY (order_num),
    -- Ensures each bill is connected to one customer
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE,
    -- Ensures a payment method is used to checkout
    FOREIGN KEY (payment) REFERENCES Payment_method(payment_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE,
    -- Ensures the books identity
    FOREIGN KEY (book_id) REFERENCES Books(ISBN)
    ON UPDATE CASCADE
	ON DELETE CASCADE
);

-- A customer can have an account but they may not have something in their cart so their customer_id will not display here 
INSERT INTO Cart(order_num, customer_id, book_id, quantity, total_price, payment, cart_date) VALUES
(1, 00001, '978-0-12-374856-0', 1, 120.00, 1, '11/24/17'),
(2, 00001, '978-0-07-246563-1', 2, 220.00, 1, '11/24/17'),
(3, 00001, '0-1153-2555-5', 1, 30.00, 1, '11/24/17');

INSERT INTO Cart(order_num, customer_id, book_id, quantity, total_price, payment, cart_date) VALUES
(4, 00002, '978-0-12-374856-0', 1, 120.00, 2, '11/23/17'),
(5, 00002, '978-0-07-246563-1', 1, 110.00, 2, '11/23/17'),
(6, 00002, '0-1153-2555-5', 1, 30.00, 2, '11/23/17');

INSERT INTO Cart(order_num, customer_id, book_id, quantity, total_price, payment, cart_date) VALUES
(7, 00003, '978-0-12-374856-0', 1, 120.00, 3, '12/01/17'),
(8, 00003, '978-0-07-246563-1', 1, 110.00, 3, '12/01/17'),
(9, 00003, '0-1153-2555-5', 1, 30.00, 3, '12/01/17'),
(10, 00003, '0-8053-1755-4', 1, 100.00, 3, '12/01/17');

INSERT INTO Cart(order_num, customer_id, book_id, quantity, total_price, payment, cart_date) VALUES
(11, 00004, '978-0-12-374856-0', 1, 120.00, 4, '11/24/17'),
(12, 00004, '978-0-07-246563-1', 1, 110.00, 4, '11/24/17'),
(13, 00004, '0-1153-2555-5', 2, 60.00, 4, '11/24/17'),
(14, 00004, '0-8053-1755-4', 1, 100.00, 4, '11/24/17');

-- 3.1
SELECT fname, lname
FROM Customers
WHERE customer_id NOT IN (
	SELECT customer_id 
    FROM Cart
);

-- 3.2
SELECT fname, lname
FROM Customers
JOIN Cart
ON Customers.customer_id = Cart.customer_id
JOIN Books
ON Cart.book_id = Books.ISBN
WHERE title = 'Writing Skills';

-- 3.3
SELECT fname, lname
FROM Customers
JOIN Cart
ON Customers.customer_id = Cart.customer_id
GROUP BY fname, lname
HAVING COUNT(*) > 2;

-- 3.4.1
SELECT title, SUM(Cart.quantity)
FROM Books
JOIN Cart
ON Cart.book_id = Books.ISBN
GROUP BY title
ORDER BY SUM(Cart.quantity) DESC;

-- 3.4.2
SELECT DISTINCT Books.title, SUM(quantity) AS count, Customers.gender
FROM Books
JOIN Cart
ON Cart.book_id = Books.ISBN
JOIN Customers
ON Customers.customer_id = Cart.customer_id
WHERE Customers.gender = 'F'
GROUP BY Books.title, Customers.gender
ORDER BY count DESC;

-- 3.5
SELECT COUNT(customer_id)
FROM Payment_method
WHERE account_type = 'Credit';

-- 3.6
SELECT MAX(zipcode) AS max, COUNT(zipcode) AS count
FROM Customers
GROUP BY zipcode
ORDER BY count DESC;

-- 3.7
SELECT fname, lname, SUM(total_price) AS books_purchased
FROM Customers
JOIN Cart
ON Customers.customer_id = Cart.customer_id
GROUP BY Customers.customer_id
ORDER BY books_purchased DESC;
