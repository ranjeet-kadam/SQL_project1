# SQL_project1
# Retail Sales Analysis


**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `[sql_project]`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `[sql_project]`.
- **Table Creation**: A table named `retail_sales1` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE [sql_project];

CREATE TABLE retail_sales1
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales1;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales1;
SELECT DISTINCT category FROM retail_sales1;

SELECT * FROM retail_sales1
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales1
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales1
WHERE [sale_date] ='2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT *
FROM retail_sales1
WHERE category ='Clothing'
AND [sale_date] between '2022-11-01' AND '2022-11-30'
AND [quantiy] >=4;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales1
GROUP BY category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales1
WHERE category = 'Beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales1
WHERE total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales1
GROUP 
    BY 
    category,
    gender
ORDER BY 1
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
WITH monthlySales as
(	
	SELECT YEAR(sale_date) AS year,
		   MONTH(sale_date) AS month,
		   AVG([total_sale]) AS avg_sale,
		   RANK () OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG([total_sale]) desc) AS rank
  FROM retail_sales1
  GROUP BY YEAR(sale_date),month(sale_date)
)

SELECT year,month,avg_sale 
FROM monthlySales
WHERE rank =1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales**:
```sql
SELECT [customer_id],SUM(total_sale) AS total_sale
FROM retail_sales1
GROUP BY [customer_id]
ORDER BY  [total_sale] DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN DATEPART(hour,sale_time)<12 THEN 'Morning'
			  WHEN DATEPART(hour,sale_time) BETWEEN 12 and 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales1
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
```

11. **Write a SQL query to find the average quantity sold per transaction for each category.**:
```sql
SELECT 
    category,
    AVG(quantiy) AS avg_quantity_per_transaction
FROM 
    retail_sales1
GROUP BY 
    category;
```

12. ** Write a SQL query to find the most frequent purchase hour for each customer.**:
```sql
SELECT 
    customer_id,
    DATEPART(HOUR, sale_time) AS purchase_hour,
    COUNT(*) AS frequency
FROM 
    retail_sales1
GROUP BY 
    customer_id,
    DATEPART(HOUR, sale_time)
ORDER BY 
    customer_id,
    frequency DESC;
```

13. **Write a SQL query to calculate the total profit (assuming profit = total_sale - cogs) for each category.**:
```sql
SELECT 
    category,
    SUM(total_sale - cogs) AS total_profit
FROM 
    retail_sales1
GROUP BY 
    category;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Total Sales by Category**: The total sales amount for each category. This data highlights which categories are the most and least profitable.
- **Gender-Based Analysis**: The number of transactions made by each gender across different categories was determined. This helps in understanding gender preferences and potentially tailoring marketing efforts.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.
- **Sales Distribution by Time of Day**: The number of orders placed in different shifts (Morning, Afternoon, Evening) was determined. This analysis is important for optimizing staffing, operational hours, and marketing efforts.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Best-Selling Month**: The best-selling month in each year was identified based on average sales. This is critical for understanding seasonality and planning inventory and promotions accordingly.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

- **Key Performance Insights**:

- The dataset reveals that sales vary significantly across categories, customer demographics, and time shifts.
- High-value transactions and top customers indicate where targeted efforts might yield the most significant returns.
- The seasonal trends identified in monthly sales can inform strategic planning for inventory, promotions, and staffing.

- **Recommendations**:

- **Focus on High-Performing Categories**: Invest more in categories that have higher total sales and diverse customer bases.
- **Leverage Customer Insights**: Use demographic insights, such as age and gender preferences, to tailor marketing campaigns.
- **Optimize Operations**: Align staffing and operational hours with the peak sales times identified (Morning, Afternoon, Evening).
- **Target High-Value Customers**: Develop loyalty programs or special offers for top customers to encourage repeat business.

