#sql retail analysis 
create database sql_project_1;
use sql_project_1;

#create table 
create table retail_sales 
(
 transactions_id int primary key,
 sale_date	date ,
 sale_time	time ,
 customer_id int ,	
 gender	varchar(15),
 age int null ,
 category varchar(20),
 quantiy int null ,
 price_per_unit	 float null ,
 cogs float null ,
 total_sale float null
 );  
 
#count
select count(*) from retail_sales;
#checking null values 
select * from retail_sales where age is null ;
select * from retail_sales where quantiy is null;
select * from retail_sales where sale_date is null;
select * from retail_sales where sale_time is null;
# Data cleaning 
select * from retail_sales where transactions_id is null
or sale_date is null
or sale_time is null
or gender is null
or category is null
or quantiy is null
or cogs is null
or total_sale is null ;
#before delete in mysql workbench 
SET SQL_SAFE_UPDATES = 0;
#delete
delete from retail_sales
where transactions_id is null
or sale_date is null
or sale_time is null
or gender is null
or category is null
or quantiy is null
or cogs is null
or total_sale is null ;  
# Data Exploration 
#How many sales we have 
select count(*) as total_sales from retail_sales;
#how many customer 
select count(customer_id) as total_customer  from retail_sales;
# Unique Customer 
select distinct(customer_id) as proper_customer from retail_sales;
select count(distinct(customer_id))as proper_customer from retail_sales;
#unique category 
select count(distinct(category))as unique_cat from retail_sales;
select distinct(category)as unique_cat from retail_sales;

# data analysis $ business key problem & answers
#q1 write a query to retrive all the column for sales made on '2022-11-05'
select * from retail_sales where sale_date = '2022-11-05';

#q2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
select * from retail_sales where category = 'clothing' and quantiy>= 4 and sale_date between '2022-11-01' and '2022-11-30';

#q3Write a SQL query to calculate the total sales (total_sale) for each category. 
select sum(total_sale) as total_sales,category,count(transactions_id) as total_orders from retail_sales group by category ;

#q4 write a query to find the average age of customer who purchased items from the beauty category 
select round(avg(age)) as age , category  from retail_sales where category = 'beauty';  

#q5 write a sql query to find all transactions where the total_sale is greater than 1000
select * from retail_sales where total_sale > 1000;  

#q6 write a sql query to find total number of transactions made by each gender and by each category 
select count(*)as transactions , gender , category from retail_sales group by gender , category order by category ;  

#q7 write a sql query to calculate the average sale for each month . Find best selling month in each year 
select
month , year , avg_sale
from
(
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS avg_sale,
   rank() over(partition by extract(year from sale_date)
   order by avg(total_sale) Desc ) as rank1
   from retail_sales
GROUP BY year, month
ORDER BY year, month
) as t1
where rank1 = 1;  

#q8 write a query to find top five customers based on the highest total sale 

select * from retail_sales order by total_sale desc limit 5;
select customer_id,sum(total_sale) as total_sale1 from retail_sales group by customer_id order by total_sale1 desc limit 5; 

#q9 write a query to find number of unique customers who purchased items from unique category 

select count(distinct(customer_id)) as unique_customer ,category from retail_sales group by category ; 

#q10 write a sql query to create each shift and number of orders ( example morning<=12,afternoon between 12 & 17,evening >17)
select count(*),shift from
(select * , case
when extract(hour from sale_time) < 12 
then 'Morning'
when extract(hour from sale_time) between 12 and 17 
then 'afternoon'
else 
'evening' 
end as 'shift'
 from retail_sales)
 as t1
 group by shift;
 
 #end of project 