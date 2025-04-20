-- create database 
CREATE DATABASE supermarket_db;

-- create table 'supermarket_sales'
CREATE TABLE supermarket_sales (
invoice_id VARCHAR(12),
branch VARCHAR(2),
city VARCHAR(20),
customer_type VARCHAR(20),
gender VARCHAR(10),
product_line VARCHAR(50),
unit_price DOUBLE,
quantity INT,
tax DOUBLE,
total DOUBLE,
purchase_date DATE,
purchase_time TIME,
payment VARCHAR(20),
cogs DOUBLE,
gross_margin_percentage DOUBLE,
gross_income DOUBLE,
rating DOUBLE,
Selling_price_per_unit DOUBLE
);

-- Then Import the csv file Through Table Data Import Wizard 


-- Data Exploration & Cleaning

-- Task 1: Determine the total number of records in the dataset
SELECT COUNT(*) FROM supermarket_sales;

-- Task 2: Identify all unique product_line in the dataset
SELECT DISTINCT product_line FROM supermarket_sales;

-- Task 3:  Check for any null values in the dataset and delete records with missing data
SELECT * FROM supermarket_sales
WHERE branch IS NULL OR city IS NULL OR customer_type IS NULL OR gender IS NULL OR product_line IS NULL OR unit_price IS NULL OR 
quantity IS NULL OR tax IS NULL OR total IS NULL OR purchase_date IS NULL OR purchase_time IS NULL OR payment IS NULL OR cogs IS NULL OR 
gross_margin_percentage IS NULL OR  gross_income IS NULL OR rating IS NULL OR selling_price_per_unit IS NULL;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM supermarket_sales 
WHERE branch IS NULL OR city IS NULL OR customer_type IS NULL OR gender IS NULL OR product_line IS NULL OR unit_price IS NULL OR 
quantity IS NULL OR tax IS NULL OR total IS NULL OR purchase_date IS NULL OR purchase_time IS NULL OR payment IS NULL OR cogs IS NULL OR 
gross_margin_percentage IS NULL OR  gross_income IS NULL OR rating IS NULL OR selling_price_per_unit IS NULL;


-- Data Analysis and Business Findings 

-- Basic Level Queries 

-- Task 1: write a query to find total sales amount
SELECT ROUND(SUM(total),2) as total_sales 
FROM supermarket_sales;

-- Task 2: write a query to find which city has the highest total sales
SELECT city, ROUND(SUM(total),2) as total_sales 
FROM supermarket_sales
GROUP BY city
ORDER BY total_sales DESC;

-- Task 3: write a query to find how many sales were made with each payment method (Cash, Credit Card, etc.)
SELECT payment, COUNT(*) as total_sales 
FROM supermarket_sales
GROUP BY payment
ORDER BY total_sales DESC;

-- Task 4: write a query to find Which product line generates the highest sales
SELECT product_line, ROUND(SUM(total),2) as total_sales
FROM supermarket_sales
GROUP BY product_line
ORDER BY total_sales DESC
LIMIT 1;

-- Task 5: write a query to find What is the average total sales per transaction
SELECT ROUND(AVG(total),2) as avg_sale_per_trans
FROM supermarket_sales;

-- Intermediate Level Queries 

-- Task 1: write a query to find which 5 product_line are sold the most by quantity
SELECT product_line, COUNT(quantity) as total_quantity_sold
FROM supermarket_sales
GROUP BY product_line
ORDER BY total_quantity_sold DESC
LIMIT 5;

/*Task 2:  Sales Trend by month 
write a query to find what are the total sales for each month */

SELECT DATE_FORMAT(purchase_date,'%Y-%M') as date, SUM(total)as total_sales
FROM supermarket_sales
group by date;

/* Task 3: Customer Type Analysis
write a query to find are Members spending more than Non-members? */

SELECT customer_type, ROUND(SUM(total),2) as total_spend
FROM supermarket_sales
GROUP BY customer_type
ORDER BY total_spend DESC;

/* Task 4: Branch Performance
write a query to find which branch (A, B, C) is the most profitable */

SELECT branch, city, ROUND(SUM(total),2) as total_sales 
FROM supermarket_sales
GROUP BY branch,city
ORDER BY total_sales DESC;

/* Task 5: Sales by Gender
write a query to find males or females who spend more on average */

SELECT gender, ROUND(AVG(total),2) as avg_spend
FROM supermarket_sales
GROUP BY gender
ORDER BY avg_spend DESC;

/* Task 6: Gross Income by Product Line
write a query to find which product line makes the highest profit margin */

SELECT product_line, ROUND(SUM(gross_income),2) as gross_profit
FROM supermarket_sales
GROUP BY product_line
ORDER BY gross_profit DESC;

-- Task 7: write a query to find Top 3 most purchased product_line in gender category 

WITH best_selling_product_line as (
SELECT gender, product_line, COUNT(quantity) as total_quantity,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY COUNT(quantity) DESC) as rnk
FROM supermarket_sales
GROUP BY gender, product_line
)
 SELECT gender, product_line, total_quantity,rnk
 FROM best_selling_product_line 
 WHERE rnk<=3;

-- Task 8: write a query to show what time of day sees the highest number of sales 

SELECT DATE_FORMAT(purchase_time, '%h:%m %p') as hour, ROUND(SUM(total),2) as total_sales 
FROM supermarket_sales
GROUP BY hour
ORDER BY total_sales DESC;

-- Task 9: write a query to find which branch has the highest customer satisfaction based on ratings

SELECT branch, ROUND(AVG(rating),1) as avg_rating
FROM supermarket_sales
GROUP BY branch
ORDER BY avg_rating DESC;

-- Advance Level Queries 

/* Task 1: Basket Size
write a query to find what’s the average number of products bought per transaction */

SELECT AVG(total_quantity) as avg_products_per_trans
FROM (
  SELECT invoice_id, SUM(quantity) as total_quantity
  FROM supermarket_sales
  GROUP BY invoice_id
  ) as transaction_summary;

-- Task 2: write a query to find what is the moving average of total sales over the last 7 days

SELECT
  purchase_date,
  SUM(total) AS daily_sales,
  ROUND(AVG(SUM(total)) OVER (ORDER BY purchase_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS moving_avg_7_days
FROM supermarket_sales
GROUP BY purchase_date
ORDER BY purchase_date;

-- Task 3: write a query to calculate sales growth percentage over time 

WITH previous_day_sale as (
SELECT DATE_FORMAT(purchase_date, '%Y-%m-%d') as date, ROUND(SUM(total),2) as total_sales,
LAG(SUM(total)) OVER(ORDER BY DATE_FORMAT(purchase_date, '%Y-%m-%d')) as previous_day_sales
FROM supermarket_sales
GROUP BY date
)
  SELECT date, total_sales, previous_day_sales,
  ROUND((total_sales - previous_day_sales),2) as difference,
  ROUND((total_sales - previous_day_sales) *100 / previous_day_sales,2) as sales_growth_percentage
  FROM previous_day_sale;
  
  -- End of Project 