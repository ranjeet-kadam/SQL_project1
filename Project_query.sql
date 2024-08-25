select top 10* from retail_sales1;

select * from retail_sales1 order by [customer_id] offset 0 rows fetch next 10 rows only;

SELECT * 
FROM retail_sales1 
ORDER BY [transactions_id]
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY;

ALTER TABLE retail_sales1
DROP COLUMN column12,column13,column14,column15;

select count(*) from retail_sales1;

-- checking null values in table

select * from retail_sales1
where [transactions_id] is null 
or
	  [sale_date] is null 
	  or
	  [sale_time] is null 
	  or
	  [customer_id] is null 
	  or
	  [gender] is null 
	  or
	  [age] is null 
	  or
	  [category] is null 
	  or
	  [quantiy] is null 
	  or
	  [price_per_unit] is null 
	  or
	  [cogs] is null 
	  or
	  [total_sale] is null;

-- Data cleaning

delete from retail_sales1
where [transactions_id] is null 
or
	  [sale_date] is null 
	  or
	  [sale_time] is null 
	  or
	  [customer_id] is null 
	  or
	  [gender] is null 
	  or
	  [age] is null 
	  or
	  [category] is null 
	  or
	  [quantiy] is null 
	  or
	  [price_per_unit] is null 
	  or
	  [cogs] is null 
	  or
	  [total_sale] is null;

select * from retail_sales1

-- Data Exploration

-- how many total sales we have?

select count(*) as total_sales from retail_sales1;

-- how many unique customers we have?


select count(distinct customer_id) as unique_customer from retail_sales1;

-- how many unique categories we have?

select count(distinct [category]) as unique_category from retail_sales1;

select distinct category from retail_sales1;

-- Data Analysis & Business Problems & thier answers

-- Q1. Write a query to retrieve all the columns for the sales made on '2022-11-05' 

select * from retail_sales1
where [sale_date] ='2022-11-05';

-- Q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select * from retail_sales1
where category ='Clothing'
and [sale_date] between '2022-11-01' and '2022-11-30'
and [quantiy] >=4;

-- Q3 Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales1
GROUP BY category;

-- Q4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select avg(age) as average_age from retail_sales1
where category = 'Beauty';

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select * from retail_sales1
where total_sale > 1000;

-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

select [category],[gender],count(*) as total_number_of_transactions
from retail_sales1
group by [category],[gender]
order by 1;

-- Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year: Important

select [total_sale],avg([total_sale]) as avg_sale from retail_sales1
group by [total_sale]
order by 1;

with monthlySales as
(	
	select YEAR(sale_date) as year,
		   month(sale_date) as month,
		   avg([total_sale]) as avg_sale,
		   rank () over (partition by year(sale_date) order by avg([total_sale]) desc) as rank
		   from retail_sales1
		   group by YEAR(sale_date),month(sale_date)
)

select year,month,avg_sale 
from monthlySales
where rank =1;

-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales 
select [customer_id],sum(total_sale) as total_sale from retail_sales1
group by [customer_id]
order by  [total_sale] desc
offset 0 rows fetch next 5 rows only


-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.:

select category,count(distinct customer_id) as unique_customers from retail_sales1
group by category;

-- Q10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
with hourly_sale as
(
	select *,
		case 
			when DATEPART(hour,sale_time)<12 then 'Morning'
			when DATEPART(hour,sale_time) between 12 and 17 then 'Afternoon'
			else 'Evening'
		end as shift 
	from retail_sales1
)

select shift,count(*) as orders
from hourly_sale
group by shift

-- Q11. Write a SQL query to find the average quantity sold per transaction for each category.

SELECT 
    category,
    AVG(quantiy) AS avg_quantity_per_transaction
FROM 
    retail_sales1
GROUP BY 
    category;

-- Q12. Write a SQL query to find the most frequent purchase hour for each customer.

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

-- Q13. Write a SQL query to calculate the total profit (assuming profit = total_sale - cogs) for each category.
SELECT 
    category,
    SUM(total_sale - cogs) AS total_profit
FROM 
    retail_sales1
GROUP BY 
    category;
