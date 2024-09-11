-- SQL Retail Sales Analysis - P1
DROP DATABASE sql_project_p01;
CREATE DATABASE sql_project_p01;

-- Table is created 
CREATE TABLE retail_sales 
					(
					transactions_id INT PRIMARY KEY, 
					sale_date DATE , 
					sale_time TIME, 
					customer_id INT, 
					gender VARCHAR(10), 
					age INT NULL, 
					category VARCHAR(20), 
					quantiy INT NULL, 
					price_per_unit DECIMAL(10,2) NULL, 
					cogs DECIMAL(10,2) NULL, 
					total_sale DECIMAL(10,2) NULL
                    );
SELECT * FROM retail_sales LIMIT 100;

-- How many Sales in the data?
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(Distinct customer_id) AS total_customer FROM retail_sales;

-- How many Distinct categories are in the data?
SELECT COUNT(Distinct category) AS total_category FROM retail_sales;

-- Data Analysis and Business Key Problems
-- My Analysis & Findings

-- Q.1 Write an SQL query to retrieve all columns for sales made on '2022-11-05.
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write an SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing' AND quantiy >3 AND MONTH(sale_date)='11' AND YEAR(sale_date)='2022';

-- Q.3 Write an SQL query to calculate the total sales (total_sale) for each category. Also total number of orders for the category.
SELECT category, SUM(total_sale) AS total_sales, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q.4 Write an SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT category, ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;

-- Q.5 Write an SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write an SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender, COUNT(transactions_id)
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

-- Q.7 Write an SQL query to calculate the average sale for each month. Find out best selling month in each year.
WITH avg_sal AS (
				SELECT YEAR(sale_date) AS sale_year, MONTH(sale_date) AS sale_month, AVG(total_sale) AS avg_total_sale
				FROM retail_sales
				GROUP BY 1, 2
				ORDER BY 3
                ),
yearly_max_sal AS (
				SELECT sale_year, sale_month, avg_total_sale, RANK() OVER (PARTITION BY sale_year ORDER BY avg_total_sale DESC) AS rank_avg_sal
				FROM avg_sal
				GROUP BY 1, 2, 3
                )
SELECT sale_year, sale_month, avg_total_sale, rank_avg_sal
FROM yearly_max_sal 
WHERE rank_avg_sal =1
GROUP BY 1, 2
ORDER BY 1;

-- Q.8 Write an SQL query to find the top 5 customers based on the highest total sales.
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q.9 Write an SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) AS unq_cust
FROM retail_sales
GROUP BY category;

-- Q.10 Write an SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH morning_shift AS (
						SELECT *, 'Morning Shift' AS shift
                        FROM retail_sales
                        WHERE sale_time BETWEEN '00:00:00' AND '12:00:00'
                        ),
afternoon_shift AS (
						SELECT *, 'Afternoon Shift' AS shift
                        FROM retail_sales
                        WHERE sale_time BETWEEN '12:00:00' AND '17:00:00'
                        ),
evening_shift AS (
						SELECT *, 'Evening Shift' AS shift
                        FROM retail_sales
                        WHERE sale_time BETWEEN '17:00:00' AND '24:00:00'
                        )
SELECT shift, COUNT(*) AS number_of_orders
FROM morning_shift
GROUP BY shift
UNION
SELECT shift, COUNT(*) AS number_of_orders
FROM afternoon_shift
GROUP BY shift
UNION
SELECT shift, COUNT(*) AS number_of_orders
FROM evening_shift
GROUP BY shift

-- END OF PROJECT --
                        
					