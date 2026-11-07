/* ============================================================
   BANKING SYSTEM DATABASE
   MySQL 8.0+
   ============================================================ */

DROP DATABASE IF EXISTS Banking_System;

CREATE DATABASE Banking_System;

USE Banking_System;


/* ============================================================
   1. BANK CUSTOMERS
   ============================================================ */

CREATE TABLE Bank_Customers
(
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    DOB DATE NOT NULL,
    PAN_No CHAR(10) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL UNIQUE,
    City VARCHAR(50) NOT NULL
);


/* ============================================================
   2. BRANCHES
   ============================================================ */

CREATE TABLE Branches
(
    Branch_ID INT PRIMARY KEY,
    Branch_Name VARCHAR(100) NOT NULL,
    IFSC_Code CHAR(11) NOT NULL UNIQUE,
    City VARCHAR(50) NOT NULL,
    Manager_Name VARCHAR(100) NOT NULL
);


/* ============================================================
   3. ACCOUNTS
   ============================================================ */

CREATE TABLE Accounts
(
    Account_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Account_Type VARCHAR(30) NOT NULL,
    Open_Date DATE NOT NULL,
    Balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    Branch_ID INT NOT NULL,

    CONSTRAINT chk_account_type
        CHECK (Account_Type IN ('Savings', 'Current', 'Salary')),

    CONSTRAINT chk_account_balance
        CHECK (Balance >= 0),

    CONSTRAINT fk_account_customer
        FOREIGN KEY (Customer_ID)
        REFERENCES Bank_Customers(Customer_ID),

    CONSTRAINT fk_account_branch
        FOREIGN KEY (Branch_ID)
        REFERENCES Branches(Branch_ID)
);


/* ============================================================
   4. TRANSACTIONS
   ============================================================ */

CREATE TABLE Transactions
(
    Transaction_ID INT PRIMARY KEY,
    Account_ID INT NOT NULL,
    Transaction_Date DATETIME NOT NULL,
    Transaction_Type VARCHAR(20) NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    Channel VARCHAR(30) NOT NULL,

    CONSTRAINT chk_transaction_type
        CHECK (Transaction_Type IN ('CREDIT', 'DEBIT')),

    CONSTRAINT chk_transaction_amount
        CHECK (Amount > 0),

    CONSTRAINT chk_transaction_channel
        CHECK
        (
            Channel IN
            (
                'ATM',
                'UPI',
                'NEFT',
                'RTGS',
                'IMPS',
                'Internet Banking',
                'Branch'
            )
        ),

    CONSTRAINT fk_transaction_account
        FOREIGN KEY (Account_ID)
        REFERENCES Accounts(Account_ID)
);


/* ============================================================
   5. BENEFICIARIES
   ============================================================ */

CREATE TABLE Beneficiaries
(
    Beneficiary_ID INT PRIMARY KEY,
    Account_ID INT NOT NULL,
    Beneficiary_Name VARCHAR(100) NOT NULL,
    Bank_Name VARCHAR(100) NOT NULL,
    Account_Number VARCHAR(18) NOT NULL,
    IFSC_Code CHAR(11) NOT NULL,

    CONSTRAINT fk_beneficiary_account
        FOREIGN KEY (Account_ID)
        REFERENCES Accounts(Account_ID)
);


/* ============================================================
   6. LOANS
   ============================================================ */

CREATE TABLE Loans
(
    Loan_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Loan_Type VARCHAR(30) NOT NULL,
    Principal_Amount DECIMAL(15,2) NOT NULL,
    Interest_Rate DECIMAL(5,2) NOT NULL,
    EMI DECIMAL(15,2) NOT NULL,
    Outstanding_Amount DECIMAL(15,2) NOT NULL,

    CONSTRAINT chk_loan_type
        CHECK
        (
            Loan_Type IN
            (
                'Home',
                'Personal',
                'Education',
                'Vehicle',
                'Business'
            )
        ),

    CONSTRAINT chk_principal
        CHECK (Principal_Amount > 0),

    CONSTRAINT chk_interest
        CHECK
        (
            Interest_Rate >= 0
            AND Interest_Rate <= 30
        ),

    CONSTRAINT chk_emi
        CHECK (EMI > 0),

    CONSTRAINT chk_outstanding
        CHECK (Outstanding_Amount >= 0),

    CONSTRAINT fk_loan_customer
        FOREIGN KEY (Customer_ID)
        REFERENCES Bank_Customers(Customer_ID)
);


/* ============================================================
   INSERT CUSTOMERS
   ============================================================ */

INSERT INTO Bank_Customers
(Customer_ID, Customer_Name, DOB, PAN_No, Phone, City)
VALUES
(1, 'Aarav Sharma', '1995-04-12', 'ABCDE1234F', '9876500001', 'Pune'),
(2, 'Priya Verma', '1992-08-25', 'BCDEF2345G', '9876500002', 'Mumbai'),
(3, 'Rahul Kumar', '1998-01-17', 'CDEFG3456H', '9876500003', 'Patna'),
(4, 'Sneha Singh', '1994-11-03', 'DEFGH4567J', '9876500004', 'Delhi'),
(5, 'Aditya Patel', '1990-06-21', 'EFGHI5678K', '9876500005', 'Ahmedabad'),
(6, 'Neha Joshi', '1997-09-14', 'FGHIJ6789L', '9876500006', 'Nashik');


/* ============================================================
   INSERT BRANCHES
   ============================================================ */

INSERT INTO Branches
(Branch_ID, Branch_Name, IFSC_Code, City, Manager_Name)
VALUES
(101, 'Shivaji Nagar Branch', 'BKNG0000101', 'Pune', 'Rajesh Mehta'),
(102, 'Andheri Branch', 'BKNG0000102', 'Mumbai', 'Anita Rao'),
(103, 'Boring Road Branch', 'BKNG0000103', 'Patna', 'Sanjay Gupta'),
(104, 'Connaught Place Branch', 'BKNG0000104', 'Delhi', 'Vikas Malhotra'),
(105, 'Navrangpura Branch', 'BKNG0000105', 'Ahmedabad', 'Kavita Shah'),
(106, 'College Road Branch', 'BKNG0000106', 'Nashik', 'Amit Kulkarni');


/* ============================================================
   INSERT ACCOUNTS
   ============================================================ */

INSERT INTO Accounts
(Account_ID, Customer_ID, Account_Type, Open_Date, Balance, Branch_ID)
VALUES
(1001, 1, 'Savings', '2021-01-15', 85000.00, 101),
(1002, 1, 'Current', '2022-05-10', 250000.00, 101),
(1003, 1, 'Salary',  '2023-07-01', 125000.00, 102),
(1004, 2, 'Savings', '2020-03-20', 175000.00, 102),
(1005, 2, 'Current', '2021-09-12', 420000.00, 103),
(1006, 3, 'Savings', '2022-02-18', 65000.00, 103),
(1007, 3, 'Salary',  '2024-01-05', 95000.00, 103),
(1008, 4, 'Savings', '2019-11-11', 310000.00, 104),
(1009, 4, 'Current', '2020-12-01', 550000.00, 104),
(1010, 5, 'Savings', '2021-06-16', 145000.00, 105),
(1011, 5, 'Current', '2022-08-23', 375000.00, 105),
(1012, 5, 'Salary',  '2023-10-09', 110000.00, 106),
(1013, 6, 'Savings', '2020-04-14', 72000.00, 106),
(1014, 6, 'Salary',  '2023-03-27', 135000.00, 106),
(1015, 2, 'Savings', '2024-05-19', 225000.00, 102);


/* ============================================================
   INSERT TRANSACTIONS
   ============================================================ */

INSERT INTO Transactions
(Transaction_ID, Account_ID, Transaction_Date,
 Transaction_Type, Amount, Channel)
VALUES
(5001, 1001, '2026-01-05 10:15:00', 'CREDIT', 50000.00, 'UPI'),
(5002, 1001, '2026-01-18 14:20:00', 'DEBIT',  12000.00, 'ATM'),
(5003, 1002, '2026-02-02 11:10:00', 'CREDIT', 100000.00, 'NEFT'),
(5004, 1002, '2026-02-15 16:30:00', 'DEBIT',  35000.00, 'Internet Banking'),
(5005, 1004, '2026-02-20 09:45:00', 'CREDIT', 75000.00, 'Branch'),
(5006, 1005, '2026-03-01 13:15:00', 'DEBIT', 50000.00, 'RTGS'),
(5007, 1006, '2026-03-05 18:25:00', 'CREDIT', 30000.00, 'UPI'),
(5008, 1007, '2026-03-10 10:05:00', 'DEBIT',  15000.00, 'ATM'),
(5009, 1008, '2026-03-15 12:40:00', 'CREDIT', 125000.00, 'NEFT'),
(5010, 1009, '2026-03-20 15:30:00', 'DEBIT',  85000.00, 'RTGS'),
(5011, 1010, '2026-04-02 11:55:00', 'CREDIT', 60000.00, 'UPI'),
(5012, 1011, '2026-04-08 17:10:00', 'DEBIT',  45000.00, 'Internet Banking'),
(5013, 1012, '2026-04-12 09:20:00', 'CREDIT', 90000.00, 'NEFT'),
(5014, 1013, '2026-04-18 14:45:00', 'DEBIT',  10000.00, 'ATM'),
(5015, 1015, '2026-04-25 16:00:00', 'CREDIT', 80000.00, 'IMPS');


/* ============================================================
   INSERT BENEFICIARIES
   ============================================================ */

INSERT INTO Beneficiaries
(Beneficiary_ID, Account_ID, Beneficiary_Name,
 Bank_Name, Account_Number, IFSC_Code)
VALUES
(7001, 1001, 'Rohan Sharma', 'State Bank of India',
 '200001000001', 'SBIN0001001'),
(7002, 1001, 'Kunal Deshmukh', 'HDFC Bank',
 '200001000002', 'HDFC0001002'),
(7003, 1002, 'Meera Joshi', 'ICICI Bank',
 '200001000003', 'ICIC0001003'),
(7004, 1002, 'Amit Verma', 'Axis Bank',
 '200001000004', 'UTIB0001004'),
(7005, 1003, 'Pooja Singh', 'Kotak Mahindra Bank',
 '200001000005', 'KKBK0001005'),
(7006, 1004, 'Nitin Kumar', 'Punjab National Bank',
 '200001000006', 'PUNB0001006'),
(7007, 1005, 'Karan Patel', 'Bank of Baroda',
 '200001000007', 'BARB0001007'),
(7008, 1006, 'Anjali Kumari', 'State Bank of India',
 '200001000008', 'SBIN0001008'),
(7009, 1007, 'Vivek Anand', 'HDFC Bank',
 '200001000009', 'HDFC0001009'),
(7010, 1008, 'Sahil Kapoor', 'ICICI Bank',
 '200001000010', 'ICIC0001010'),
(7011, 1009, 'Ritika Malhotra', 'Axis Bank',
 '200001000011', 'UTIB0001011'),
(7012, 1010, 'Harsh Shah', 'Bank of Baroda',
 '200001000012', 'BARB0001012'),
(7013, 1011, 'Divya Patel', 'HDFC Bank',
 '200001000013', 'HDFC0001013'),
(7014, 1012, 'Manish Kulkarni', 'ICICI Bank',
 '200001000014', 'ICIC0001014'),
(7015, 1015, 'Simran Kaur', 'State Bank of India',
 '200001000015', 'SBIN0001015');


/* ============================================================
   INSERT LOANS
   ============================================================ */

INSERT INTO Loans
(Loan_ID, Customer_ID, Loan_Type, Principal_Amount,
 Interest_Rate, EMI, Outstanding_Amount)
VALUES
(9001, 1, 'Home',      4500000.00, 8.50, 39000.00, 3900000.00),
(9002, 1, 'Personal',   300000.00, 11.50, 10500.00, 180000.00),
(9003, 1, 'Vehicle',    800000.00, 9.25, 16500.00, 520000.00),
(9004, 2, 'Home',      6000000.00, 8.25, 52000.00, 5100000.00),
(9005, 2, 'Personal',   500000.00, 12.00, 12000.00, 320000.00),
(9006, 3, 'Education',  750000.00, 7.50, 11000.00, 550000.00),
(9007, 3, 'Vehicle',   1200000.00, 9.00, 25000.00, 850000.00),
(9008, 3, 'Personal',   250000.00, 11.75, 8500.00, 100000.00),
(9009, 4, 'Home',      3500000.00, 8.40, 32000.00, 2900000.00),
(9010, 4, 'Business',  2000000.00, 10.25, 45000.00, 1500000.00),
(9011, 5, 'Vehicle',   1500000.00, 9.10, 31000.00, 1050000.00),
(9012, 5, 'Business',  2500000.00, 10.00, 55000.00, 2100000.00),
(9013, 5, 'Personal',   400000.00, 12.25, 10500.00, 250000.00),
(9014, 2, 'Education',  900000.00, 7.25, 13000.00, 700000.00),
(9015, 4, 'Vehicle',   1000000.00, 9.50, 21000.00, 700000.00);

