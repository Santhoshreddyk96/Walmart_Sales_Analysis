select*from walmart_clean_data

select count(*)
from walmart_clean_data

select payment_method,count(*)
from walmart_clean_data
group by payment_method

--Total Branches
select count(distinct branch) as branches
from walmart_clean_data

select max(quantity)
from walmart_clean_data

select min(quantity)
from walmart_clean_data

--Business Problems

--1. Analyze Payment Methods and Sales

select payment_method,count(*) as total_transactions,sum(quantity) as total_quantity
from walmart_clean_data
group by payment_method

--2. Identify the Highest avg-Rated Category in Each Branch

select * from walmart_clean_data

select*
from
(
	select branch,
		   category,
		   avg(rating) as avg_rating,
		   rank() over (partition by branch order by avg(rating) desc) as rank
	from walmart_clean_data
	group by branch,category
	
) as t1
where rank=1

--3.Determine the Busiest Day for Each Branch