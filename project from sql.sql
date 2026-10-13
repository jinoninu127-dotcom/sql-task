-- ============================================================
-- E-COMMERCE DATABASE MANAGEMENT SYSTEM 
-- WEEKS 
-- ============================================================

CREATE DATABASE IF NOT EXISTS ECommerceDB;
USE ECommerceDB;

-- ============================================================
-- 1. TABLE CREATION & CONSTRAINTS
-- ============================================================

-- WEEK 1: Customer Module
CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15),
    Address TEXT
);

-- WEEK 2: Category and Product Module
CREATE TABLE Category (
    Category_ID INT PRIMARY KEY,
    Category_Name VARCHAR(50) NOT NULL UNIQUE,
    Description TEXT
);

CREATE TABLE Product (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100) NOT NULL,
    Category_ID INT,
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    Stock_Quantity INT NOT NULL CHECK (Stock_Quantity >= 0),
    FOREIGN KEY (Category_ID) REFERENCES Category(Category_ID) ON DELETE SET NULL
);

-- WEEK 3: Seller and Inventory Module
CREATE TABLE Seller (
    Seller_ID INT PRIMARY KEY,
    Seller_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15),
    Address TEXT
);

CREATE TABLE Inventory (
    Inventory_ID INT PRIMARY KEY,
    Product_ID INT,
    Seller_ID INT,
    Stock_Quantity INT NOT NULL CHECK (Stock_Quantity >= 0),
    Stock_Status VARCHAR(20) DEFAULT 'In Stock',
    Last_Updated DATE,
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID) ON DELETE CASCADE,
    FOREIGN KEY (Seller_ID) REFERENCES Seller(Seller_ID) ON DELETE CASCADE
);

-- WEEK 4: Order Management Module
CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Order_Date DATE NOT NULL,
    Total_Amount DECIMAL(12,2) NOT NULL CHECK (Total_Amount >= 0),
    Order_Status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE
);

CREATE TABLE Order_Details (
    Order_Detail_ID INT PRIMARY KEY,
    Order_ID INT,
    Product_ID INT,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID) ON DELETE CASCADE,
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID) ON DELETE CASCADE
);

-- WEEK 5: Payment Transaction Module
CREATE TABLE Payment (
    Payment_ID VARCHAR(20) PRIMARY KEY,
    Order_ID INT UNIQUE, -- Ensures 1-to-1 relationship with Orders
    Payment_Date DATE NOT NULL,
    Payment_Mode VARCHAR(50) NOT NULL,
    Payment_Status VARCHAR(20) NOT NULL,
    Transaction_Amount DECIMAL(12,2) NOT NULL CHECK (Transaction_Amount > 0),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID) ON DELETE CASCADE
);

-- ============================================================
-- 2. DATA INSERTION (SAMPLE DATA)
-- ============================================================

-- Insert Customers
INSERT INTO Customer (Customer_ID, Customer_Name, Email, Phone, Address) VALUES
(1, 'Rahul Sharma', 'rahul@example.com', '9876543210', 'Delhi'),
(2, 'Priya Singh', 'priya@example.com', '8765432109', 'Mumbai'),
(3, 'Amit Patel', 'amit@example.com', '7654321098', 'Ahmedabad');

-- Insert Categories
INSERT INTO Category (Category_ID, Category_Name, Description) VALUES
(10, 'Electronics', 'Gadgets and devices'),
(20, 'Clothing', 'Men and Women Apparel'),
(30, 'Home & Kitchen', 'Appliances and decor');

-- Insert Products (Minimum 10 records as per Week 2)
INSERT INTO Product (Product_ID, Product_Name, Category_ID, Price, Stock_Quantity) VALUES
(101, 'Smartphone', 10, 15000.00, 50),
(102, 'Laptop', 10, 45000.00, 20),
(103, 'Wireless Mouse', 10, 800.00, 100),
(104, 'Bluetooth Speaker', 10, 2500.00, 5),
(105, 'Men T-Shirt', 20, 500.00, 200),
(106, 'Jeans', 20, 1200.00, 150),
(107, 'Sneakers', 20, 2000.00, 8),
(108, 'Microwave Oven', 30, 8500.00, 15),
(109, 'Blender', 30, 1500.00, 0),
(110, 'Bedsheet', 30, 600.00, 40),
(111, 'Smart Watch', 10, 3000.00, 25);

-- Insert Sellers
INSERT INTO Seller (Seller_ID, Seller_Name, Email, Phone, Address) VALUES
(1001, 'Tech World', 'techworld@example.com', '1111111111', 'Bangalore'),
(1002, 'Fashion Hub', 'fashionhub@example.com', '2222222222', 'Surat'),
(1003, 'Home Essentials', 'home@example.com', '3333333333', 'Chennai');

-- Insert Inventory
INSERT INTO Inventory (Inventory_ID, Product_ID, Seller_ID, Stock_Quantity, Stock_Status, Last_Updated) VALUES
(1, 101, 1001, 30, 'In Stock', '2026-08-01'),
(2, 101, 1002, 20, 'In Stock', '2026-08-02'),
(3, 102, 1001, 20, 'In Stock', '2026-08-01'),
(4, 104, 1001, 5, 'Low Stock', '2026-08-05'),
(5, 105, 1002, 200, 'In Stock', '2026-08-03'),
(6, 109, 1003, 0, 'Out of Stock', '2026-08-10');

-- Insert Orders
INSERT INTO Orders (Order_ID, Customer_ID, Order_Date, Total_Amount, Order_Status) VALUES
(5001, 1, '2026-08-15', 46600.00, 'Delivered'),
(5002, 2, '2026-08-16', 1700.00, 'Pending'),
(5003, 3, '2026-08-17', 45000.00, 'Shipped');

-- Insert Order Details
INSERT INTO Order_Details (Order_Detail_ID, Order_ID, Product_ID, Quantity, Price) VALUES
(1, 5001, 102, 1, 45000.00),
(2, 5001, 103, 2, 800.00),
(3, 5002, 105, 1, 500.00),
(4, 5002, 106, 1, 1200.00),
(5, 5003, 102, 1, 45000.00);

-- Insert Payments
INSERT INTO Payment (Payment_ID, Order_ID, Payment_Date, Payment_Mode, Payment_Status, Transaction_Amount) VALUES
('P101', 5001, '2026-08-15', 'UPI', 'Success', 46600.00),
('P102', 5002, '2026-08-16', 'Card', 'Failed', 1700.00),
('P103', 5003, '2026-08-17', 'Net Banking', 'Success', 45000.00);


-- ============================================================
-- 3. CRUD & REPORTING QUERIES (WEEKS 2 TO 5)
-- ============================================================

-- ------------------------------------------------------------
-- WEEK 2: Category & Product Reports
-- ------------------------------------------------------------
-- Display all products under each category
SELECT c.Category_Name, p.Product_Name, p.Price 
FROM Category c JOIN Product p ON c.Category_ID = p.Category_ID 
ORDER BY c.Category_Name;

-- Count the number of products in each category
SELECT Category_ID, COUNT(Product_ID) AS Total_Products 
FROM Product GROUP BY Category_ID;

-- Find the highest-priced product in each category
SELECT Category_ID, MAX(Price) AS Highest_Price 
FROM Product GROUP BY Category_ID;

-- Display categories having more than 5 products
SELECT Category_ID, COUNT(Product_ID) AS Total_Products 
FROM Product GROUP BY Category_ID HAVING COUNT(Product_ID) > 5;

-- Find the average product price for each category
SELECT Category_ID, AVG(Price) AS Average_Price 
FROM Product GROUP BY Category_ID;

-- ------------------------------------------------------------
-- WEEK 3: Seller & Inventory Reports
-- ------------------------------------------------------------
-- Products supplied by each seller
SELECT s.Seller_Name, p.Product_Name, i.Stock_Quantity 
FROM Seller s 
JOIN Inventory i ON s.Seller_ID = i.Seller_ID 
JOIN Product p ON i.Product_ID = p.Product_ID;

-- Find products that are out of stock
SELECT Product_ID, Stock_Quantity 
FROM Inventory WHERE Stock_Quantity = 0;

-- Identify products with stock quantity less than 10
SELECT Product_ID, Stock_Quantity 
FROM Inventory WHERE Stock_Quantity < 10;

-- Inventory Analysis: Total products available, Out of stock, Highest stocked
SELECT 
    SUM(CASE WHEN Stock_Quantity > 0 THEN 1 ELSE 0 END) AS Total_Available_Products,
    SUM(CASE WHEN Stock_Quantity = 0 THEN 1 ELSE 0 END) AS Out_Of_Stock_Products,
    MAX(Stock_Quantity) AS Highest_Stock_Level,
    AVG(Stock_Quantity) AS Average_Inventory_Quantity
FROM Inventory;

-- ------------------------------------------------------------
-- WEEK 4: Order Management Reports
-- ------------------------------------------------------------
-- Customer Order History
SELECT c.Customer_Name, o.Order_ID, o.Order_Date, o.Total_Amount, o.Order_Status
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID;

-- Product-wise Order Report
SELECT p.Product_Name, COUNT(od.Order_ID) AS Times_Ordered, SUM(od.Quantity) AS Total_Quantity_Sold
FROM Product p
JOIN Order_Details od ON p.Product_ID = od.Product_ID
GROUP BY p.Product_ID, p.Product_Name;

-- Customer Purchase Analysis
SELECT c.Customer_Name, COUNT(o.Order_ID) AS Total_Orders, SUM(o.Total_Amount) AS Total_Spent, AVG(o.Total_Amount) AS Avg_Order_Value
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Spent DESC;

-- ------------------------------------------------------------
-- WEEK 5: Payment Transaction Reports
-- ------------------------------------------------------------
-- Display all successful payments
SELECT * FROM Payment WHERE Payment_Status = 'Success';

-- Find failed transactions
SELECT * FROM Payment WHERE Payment_Status = 'Failed';

-- Count total successful and failed payments
SELECT Payment_Status, COUNT(*) AS Total_Transactions 
FROM Payment GROUP BY Payment_Status;

-- Payment Mode Analysis
SELECT Payment_Mode, COUNT(*) AS Transaction_Count 
FROM Payment GROUP BY Payment_Mode 
ORDER BY Transaction_Count DESC;

-- Revenue Analysis
SELECT 
    SUM(Transaction_Amount) AS Total_Revenue,
    AVG(Transaction_Amount) AS Avg_Transaction_Amount
FROM Payment WHERE Payment_Status = 'Success';

-- Revenue by payment method
SELECT Payment_Mode, SUM(Transaction_Amount) AS Revenue_Generated
FROM Payment WHERE Payment_Status = 'Success'
GROUP BY Payment_Mode;

-- Customer Payment History
SELECT c.Customer_Name, p.Order_ID, p.Payment_Mode, p.Transaction_Amount, p.Payment_Status
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN Payment p ON o.Order_ID = p.Order_ID;