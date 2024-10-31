DROP DATABASE IF EXISTS library;

CREATE DATABASE library;

USE library;

-- Entity
CREATE TABLE librarian(
    fname VARCHAR(20),
    lname VARCHAR(20),
    number INT,
    phone VARCHAR(20),
    ID INT,
    ssn VARCHAR(20),
    PRIMARY KEY (number)
);

-- Entity
CREATE TABLE section(
    number INT,
    description VARCHAR(30),
    name VARCHAR(20),
    -- Total Participation
    librarian_ID INT NOT NULL,
    PRIMARY KEY (number),
    FOREIGN KEY (librarian_ID) REFERENCES librarian(number)
    ON DELETE NO ACTION 
    ON UPDATE CASCADE
    -- Many To One relationship. Every Section is managed by one librarian
    -- Null prevents the deletion of librarian_ID
);

-- Entity
CREATE TABLE book(
    title VARCHAR(20),
    ISBN VARCHAR(20),
    call_number VARCHAR(20),
    year year,
    number INT,
    ID INT,
    -- Total Participation
    section_number INT NOT NULL,
	UNIQUE (section_number),
    publisher VARCHAR(20),
    PRIMARY KEY (ISBN),
    FOREIGN KEY (section_number) REFERENCES section(number)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    -- Many to One relationships. Many books can belong to a section.
);

-- Entity
-- Has-a relationship to book
CREATE TABLE book_copy(
    ID INT,
    -- Total Participation
    ISBN_copy VARCHAR(20) NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (ISBN_copy) REFERENCES book(ISBN)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    -- One To Many relationship. A book can have many copies
);

-- Entity
-- Holds the author of each books info
CREATE TABLE author(
    ID INT,
    sex VARCHAR(10),
    lname VARCHAR(20),
    fname VARCHAR(20),
    PRIMARY KEY (ID)
);

-- Entity
-- Holds member information
CREATE TABLE member(
    membership_number INT,
    drivers_license_number VARCHAR(20),
    phone_number VARCHAR(20),
    birthday DATE,
    ID INT,
    PRIMARY KEY (membership_number)
);

-- Has-a Entity
-- Holds Address information for Librarian and Members
CREATE TABLE address(
    ID INT,
    city VARCHAR(20),
    street_number INT,
    state VARCHAR(20),
    street_name VARCHAR(20),
    zip INT,
    PRIMARY KEY (ID),
    FOREIGN KEY (ID) REFERENCES librarian(number)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    -- One to One relationship. A librarian can have one address
    FOREIGN KEY (ID) REFERENCES member(membership_number)
    ON DELETE CASCADE
    ON UPDATE CASCADE 
    -- One to One relationship. A member can have one address
);

-- Junction table to represent the relationship from books and authors
CREATE TABLE writes_books(
    ISBN VARCHAR(20),
    ID INT,
    PRIMARY KEY (ISBN, ID),
    FOREIGN KEY (ISBN) REFERENCES book(ISBN)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (ID) REFERENCES author(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    -- Many to Many relationships. An author can write many books thus ISBN and ID are referenced
);

-- Relationship
-- Represents that holds can be placed on books
CREATE TABLE hold(
    hold_date DATE,
    membership_number INT,
    ID INT,
    PRIMARY KEY (membership_number, ID, hold_date),
    FOREIGN KEY (membership_number) REFERENCES member(membership_number)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    -- One To Many relationship. A member can hold many books.
    FOREIGN KEY (ID) REFERENCES book_copy(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    -- One To Many relationship. A book copy can have multiple holds placed on it.
);

-- Junction table used to record borrowing transcations from librraians, members and book copies
CREATE TABLE librarian_member_borrow(
    borrow_date DATE,
    due_date DATE,
    number INT,
    ID INT,
    membership_number INT,
    PRIMARY KEY (membership_number, borrow_date),
    FOREIGN KEY (membership_number) REFERENCES member(membership_number)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    -- One To Many relationship. A member can borrow many books
    FOREIGN KEY (number) REFERENCES librarian(number)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    -- One to Many relatiinship. A librarian can discharge many books
    FOREIGN KEY (ID) REFERENCES book_copy(ID)
    ON DELETE SET NULL
    ON UPDATE CASCADE
    -- One to Many relationship. A book copy can be borrowed many times.
    -- Value can be null when nobody borrows. Partial Participation as some may not be borrowed
);

-- Insert a new librarian into the librarian table.
INSERT INTO librarian (number, fname, lname, phone, ssn)
VALUES (1, 'John', 'Doe', '1234567890', '987-65-4321');

-- Insert another librarian.
INSERT INTO librarian (number, fname, lname, phone, ssn)
VALUES (2, 'Jane', 'Smith', '0987654321', '123-45-6789');

-- Insert a new member into the member table.
INSERT INTO member (membership_number, drivers_license_number, phone_number, birthday, ID)
VALUES (101, 55555555, 1234567890, '1990-05-12', 1);

-- Insert another member.
INSERT INTO member (membership_number, drivers_license_number, phone_number, birthday, ID)
VALUES (102, 66666666, 9876543210, '1985-07-23', 2);


