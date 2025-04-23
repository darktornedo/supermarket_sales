# Supermarket Sales Analytics SQL Project
## Project Overview

**Project Title**: Supermarket Sales Analysis
**Database**: `supermarket_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a supermarket sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objectives

1. **Set up a supermarket sales database**: Create and populate database with the provided dataset.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the dataset.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `supermarket_db`.
- **Table Creation**: A table named `supermarket_sales` is created to store the sales data. The table structure includes columns for invoice ID, branch, city, customer type, gender, product line, unit price, quantity, tax, total, purchase date, purchase time, payment, cogs, gross margin percentage, gross income, rating, selling price per unit. 

```sql
CREATE DATABASE supermarket_db;

CREATE TABLE supermarket_sales
(
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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Product line Count**: Identify all unique product line in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM supermarket_sales;
SELECT DISTINCT product line FROM supermarket_sales;

SELECT * FROM supermarket_sales
WHERE 
    SELECT * FROM supermarket_sales
WHERE branch IS NULL OR city IS NULL OR customer_type IS NULL OR gender IS NULL OR product_line IS NULL OR unit_price IS NULL OR 
quantity IS NULL OR tax IS NULL OR total IS NULL OR purchase_date IS NULL OR purchase_time IS NULL OR payment IS NULL OR cogs IS NULL OR 
gross_margin_percentage IS NULL OR  gross_income IS NULL OR rating IS NULL OR selling_price_per_unit IS NULL;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM retail_sales
WHERE 
    SELECT * FROM supermarket_sales
WHERE branch IS NULL OR city IS NULL OR customer_type IS NULL OR gender IS NULL OR product_line IS NULL OR unit_price IS NULL OR 
quantity IS NULL OR tax IS NULL OR total IS NULL OR purchase_date IS NULL OR purchase_time IS NULL OR payment IS NULL OR cogs IS NULL OR 
gross_margin_percentage IS NULL OR  gross_income IS NULL OR rating IS NULL OR selling_price_per_unit IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

#### Basic Level Queries 

1. **Task 1: write a query to find total sales amount**:
```sql
SELECT ROUND(SUM(total),2) as total_sales 
FROM supermarket_sales;
```

2. **Task 2: write a query to find which city has the highest total sales**:
```sql
SELECT city, ROUND(SUM(total),2) as total_sales 
FROM supermarket_sales
GROUP BY city
ORDER BY total_sales DESC;
```

3. **Task 3: write a query to find how many sales were made with each payment method (Cash, Credit Card, etc.)**:
```sql
SELECT payment, COUNT(*) as total_sales 
FROM supermarket_sales
GROUP BY payment
ORDER BY total_sales DESC;
```

4. **Task 4: write a query to find Which product line generates the highest sales**:
```sql
SELECT product_line, ROUND(SUM(total),2) as total_sales
FROM supermarket_sales
GROUP BY product_line
ORDER BY total_sales DESC
LIMIT 1;
```

5. **Task 5: write a query to find What is the average total sales per transaction**:
```sql
SELECT ROUND(AVG(total),2) as avg_sale_per_trans
FROM supermarket_sales;
```

#### Intermediate Level Queries 
1. **Task 1: write a query to find which 5 product_line are sold the most by quantity**:
```sql
SELECT product_line, COUNT(quantity) as total_quantity_sold
FROM supermarket_sales
GROUP BY product_line
ORDER BY total_quantity_sold DESC
LIMIT 5;
```

2. **Task 2: Sales Trend by month 
write a query to find what are the total sales for each month**:
```sql
SELECT DATE_FORMAT(purchase_date,'%Y-%M') as date, SUM(total)as total_sales
FROM supermarket_sales
group by date;
```

3. **Task 3: Branch Performance
write a query to find which branch (A, B, C) is the most profitable**:
```sql
SELECT branch, city, ROUND(SUM(total),2) as total_sales 
FROM supermarket_sales
GROUP BY branch,city
ORDER BY total_sales DESC;
```

4. **Task 4: Customer Type Analysis
write a query to find aare Members spending more than Non-members?**:
```sql
SELECT customer_type, ROUND(SUM(total),2) as total_spend
FROM supermarket_sales
GROUP BY customer_type
ORDER BY total_spend DESC;
```

5. **Task 5: Sales by Gender
write a query to find males or females who spend more on average**:
```sql
SELECT gender, ROUND(AVG(total),2) as avg_spend
FROM supermarket_sales
GROUP BY gender
ORDER BY avg_spend DESC;
```

6. **Task 6: Gross Income by Product Line
write a query to find which product line makes the highest profit margin**:
```sql
SELECT product_line, ROUND(SUM(gross_income),2) as gross_profit
FROM supermarket_sales
GROUP BY product_line
ORDER BY gross_profit DESC;
```

7. **Task 7: write a query to find Top 3 most purchased product_line in gender category**:
```sql
WITH best_selling_product_line as (
SELECT gender, product_line, COUNT(quantity) as total_quantity,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY COUNT(quantity) DESC) as rnk
FROM supermarket_sales
GROUP BY gender, product_line
)
 SELECT gender, product_line, total_quantity,rnk
 FROM best_selling_product_line 
 WHERE rnk<=3;
```

8. **Task 8: write a query to show what time of day sees the highest number of sales**:
```sql
SELECT DATE_FORMAT(purchase_time, '%h:%m %p') as hour, ROUND(SUM(total),2) as total_sales 
FROM supermarket_sales
GROUP BY hour
ORDER BY total_sales DESC;
```

9. **Task 9: write a query to find which branch has the highest customer satisfaction based on ratings**:
```sql
SELECT branch, ROUND(AVG(rating),1) as avg_rating
FROM supermarket_sales
GROUP BY branch
ORDER BY avg_rating DESC;
```

#### Advance Level Queries 

1. **Task 1: Basket Size
write a query to find what’s the average number of products bought per transaction**:
```sql
SELECT AVG(total_quantity) as avg_products_per_trans
FROM (
  SELECT invoice_id, SUM(quantity) as total_quantity
  FROM supermarket_sales
  GROUP BY invoice_id
  ) as transaction_summary;
```

2. **Task 2: write a query to find what is the moving average of total sales over the last 7 days**:
```sql
SELECT
  purchase_date,
  SUM(total) AS daily_sales,
  ROUND(AVG(SUM(total)) OVER (ORDER BY purchase_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS moving_avg_7_days
FROM supermarket_sales
GROUP BY purchase_date
ORDER BY purchase_date;
```

3. **Task 3: write a query to calculate sales growth percentage over time**:
```sql
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
```
## Recommendation
  1. Based on the high sales of Food and Beverages, the supermarket should increase inventory and run targeted promotions for this category to maximize revenue.
  2. Branch B has lower sales and ratings compared to Branch A and C. Management should investigate local factors and run special offers or community events to boost sales. 
  3. Peak hours occur mainly at 7 PM. Staffing should be optimized during that hour to reduce wait times and improve customer experience.
  4. Customers made more payments with Ewallet then other payment methods so try to give 5% or 10% discount whenever customers made payments with Ewallet.
  5. Members spend more then Non-Members try Expand loyalty program and give member-only offers.
  6. In Gender category Female purchased more Fashion accessories products and Male purchased Health and beauty products, try giving them a special discount on these items they purchased most.
  7. Average number of products brought per transaction is 5 so declare a offer that when a customer purchased 5 or more then 5 products they can get 1 product for free.
  8. The least selling product line is Health and beauty but it's the most purchased product line in Male category and least purchased product line in Female category try introducing more varieties in this product line for Female's.
