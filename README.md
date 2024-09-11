# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
DROP DATABASE sql_project_p01;
CREATE DATABASE sql_project_p01;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) AS total_sales
FROM retail_sales;

SELECT COUNT(Distinct customer_id) AS total_customer
FROM retail_sales;

SELECT COUNT(Distinct category) AS total_category
FROM retail_sales;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022**:
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing' AND quantiy >3 AND MONTH(sale_date)='11' AND YEAR(sale_date)='2022';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT category,
        SUM(total_sale) AS total_sales,
        COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT category,
        ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT category,
        gender,
        COUNT(transactions_id)
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
WITH avg_sal AS (
		SELECT YEAR(sale_date) AS sale_year,
                        MONTH(sale_date) AS sale_month,
                        AVG(total_sale) AS avg_total_sale
		FROM retail_sales
		GROUP BY 1, 2
		ORDER BY 3
                ),
yearly_max_sal AS (
		SELECT sale_year,
                        sale_month,
                        avg_total_sale,
			RANK() OVER (PARTITION BY sale_year ORDER BY avg_total_sale DESC) AS rank_avg_sal
		FROM avg_sal
		GROUP BY 1, 2, 3
                )
SELECT sale_year,
        sale_month,
        avg_total_sale,
        rank_avg_sal
FROM yearly_max_sal 
WHERE rank_avg_sal =1
GROUP BY 1, 2
ORDER BY 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT category,
        COUNT(DISTINCT customer_id) AS unq_cust
FROM retail_sales
GROUP BY category;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT category,
        COUNT(DISTINCT customer_id) AS unq_cust
FROM retail_sales
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
SELECT shift,
        COUNT(*) AS number_of_orders
FROM morning_shift
GROUP BY shift
UNION
SELECT shift,
        COUNT(*) AS number_of_orders
FROM afternoon_shift
GROUP BY shift
UNION
SELECT shift,
        COUNT(*) AS number_of_orders
FROM evening_shift
GROUP BY shift;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Priyanka Pandey

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and Join the Community

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media and join our community:

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/priyanka-pandey-4a1309117/)

Thank you for your support, and I look forward to connecting with you!
