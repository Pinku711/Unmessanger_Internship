-- Assignment-1--
CREATE DATABASE ORG;
USE ORG;
CREATE TABLE Customers (
CustomerID INT PRIMARY KEY,
Name VARCHAR(255),
Email VARCHAR(255),
JoinDate DATE
);
CREATE TABLE Products (
ProductID INT PRIMARY KEY,
Name VARCHAR(255),
Category VARCHAR(255),
Price DECIMAL(10, 2)
);
CREATE TABLE Orders (
OrderID INT PRIMARY KEY,
CustomerID INT,
OrderDate DATE,
TotalAmount DECIMAL(10, 2),
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE OrderDetails (
OrderDetailID INT PRIMARY KEY,
OrderID INT,
ProductID INT,
Quantity INT,
PricePerUnit DECIMAL(10, 2),
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
INSERT INTO Customers (CustomerID, Name, Email, JoinDate) VALUES
(01, 'psgautam', 'psgautam@unmessanger.com', '2020-01-10'),
(02, 'John Doe', 'JohnDoe@unmessanger.com', '2020-01-15'),
(03, 'Kiran Polard', 'Kiran@unmessanger.com', '2020-01-17'),
(04, 'Albert Einsten','Einsteen@unmessanger.com', '2020-01-19'),
(05, 'Surya Prakash', 'Suryaprakash@unmessanger.com', '2020-01-20'),
(06, 'Kashyap Seth', 'Kashyap@unmessanger.com', '2020-01-22'),
(07, 'Ved Prakash', 'vedprakash@unmessanger.com', '2020-01-25'),
(08, 'Hallen Christian', 'Hallenchristian@unmessanger.com', '2020-01-27'),
(09, 'Jivesh Gautam', 'Jivesh@unmessanger.com', '2020-01-29'),
(10, 'Tanya Gautam', 'Tanya@unmessanger.com', '2020-01-31');

INSERT INTO Products (ProductID, Name, Category, Price) VALUES
(1, 'Laptop', 'Electronics', 9999.99),
(2, 'Smartphone', 'Electronics', 10999.99),
(3, 'Washing Machine', 'Electronics', 8999.99),
(4, 'Fridge', 'Electronics', 19999.99),
(5, 'Gas Chullah', 'Kitchen', 7999.99),
(6, 'Jeans & T-Shirt', 'Clothing', 10125.99),
(7, 'Bluetooth', 'Electronics', 4150.99),
(8, 'Printing Paper', 'Stationary', 320.99),
(9, 'Bed', 'Furniture', 11290.99),  
(10, 'Fancy light', 'Home Decor', 5499.99);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES
(101, 01, '2023-10-15', 14999.98),
(102, 02, '2023-10-17', 15999.98),
(103, 03, '2023-10-20', 17999.97), 
(104, 04, '2023-10-22', 19999.96),
(105, 05, '2023-10-23', 20199.98),
(106, 06, '2023-10-25', 22999.99),
(107, 07, '2023-10-27', 24999.95),
(108, 08, '2023-10-29', 27999.96), 
(109, 09, '2023-11-05', 29999.97),
(110, 10, '2023-11-15', 30999.99);

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity,
PricePerUnit) VALUES
(101, 101, 11, 2, 999.99),
(102, 102, 12, 2, 499.99),
(103, 103, 13, 1, 5999.99),
(104, 104, 14, 4, 6999.99),
(105, 105, 15, 2, 8999.99),
(106, 106, 16, 1, 9999.99),
(107, 107, 17, 5, 1099.99),
(108, 108, 18, 4, 11999.99),
(109, 109, 19, 3, 12999.99),
(110, 110, 20, 1, 13999.99);

-- After Executing the above query, Answer the following questions with
-- writing the appropriate queries.
-- 1. Basic Queries:
-- 1.1. List all customers.
select * from customers;

-- 1.2. Show all products in the 'Electronics' category.
select * from products where category = 'Electronics';

-- 1.3. Find the total number of orders placed.
select count(*) as total_orders_placed from orders;

-- 1.4. Display the details of the most recent order.
select OrderDate from orders order by OrderDate desc limit 1;

-- 2. Joins and Relationships:
-- 2.1. List all products along with the names of the customers who ordered them.
SELECT Products.Name, Customers.Name FROM Products INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;
     
-- 2.2. Show orders that include more than one product.
SELECT Orders.OrderID, COUNT(OrderDetails.OrderDetailID) AS num_products FROM Orders
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID GROUP BY Orders.OrderID HAVING COUNT(OrderDetails.OrderDetailID) > 1;

-- 2.3. Find the total sales amount for each customer.
SELECT Customers.CustomerID, Customers.Name, SUM(Orders.TotalAmount) AS total_sales_amount
FROM Customers INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, Customers.Name;

-- 3. Aggregation and Grouping:
-- 3.1. Calculate the total revenue generated by each product category.
SELECT Category, SUM(Price) AS total_revenue
FROM Products
GROUP BY Category;

-- 3.2. Determine the average order value.
SELECT AVG(TotalAmount) AS average_order_value
FROM Orders;

-- 3.3. Find the month with the highest number of orders.
SELECT MONTH(OrderDate) AS month, COUNT(*) AS order_count FROM Orders GROUP BY month ORDER BY order_count DESC LIMIT 1;

-- 4. Subqueries and Nested Queries:
-- 4.1. Identify customers who have not placed any orders.
SELECT * FROM Customers WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);

-- 4.2. Find products that have never been ordered.
SELECT * FROM Products WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM OrderDetails);

-- 4.3. Show the top 3 best-selling products.
SELECT  Products.Name,SUM(OrderDetails.Quantity) AS total_quantity_sold FROM  Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID GROUP BY  Products.Name ORDER BY  total_quantity_sold DESC LIMIT  3;

-- 5. Date and Time Functions:
-- 5.1. List orders placed in the last month.
SELECT * FROM Orders WHERE OrderDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 5.2. Determine the oldest customer in terms of membership duration.
SELECT * FROM Customers ORDER BY JoinDate LIMIT 1;

-- 6. Advanced Queries:
-- 6.1. Rank customers based on their total spending.
SELECT CustomerID, Name, SUM(TotalAmount) AS total_spending FROM Orders JOIN Customers USING (CustomerID) GROUP BY CustomerID, Name ORDER BY total_spending DESC;

-- 6.2. Identify the most popular product category.
SELECT Category, COUNT(*) AS total_products FROM Products GROUP BY  Category ORDER BY  total_products DESC
LIMIT 1;

-- 6.3. Calculate the month-over-month growth rate in sales.
SELECT MONTH(OrderDate) AS month, SUM(TotalAmount) AS total_sales FROM Orders GROUP BY month ORDER BY month;

-- 7. Data Manipulation and Updates:
-- 7.1. Add a new customer to the Customers table.
INSERT INTO  Customers (CustomerID, Name, Email, JoinDate) VALUES
  (11,'Arujn Hegde','Arjunhegde@unmessanger.com','2023-09-25');
  
-- 7.2. Update the price of a specific product.
UPDATE Products SET Price = 7999.99 WHERE ProductID = 11;