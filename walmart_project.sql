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

--3.Determine the Busiest Day for Each Branchselect*from(select branch,datename(weekday,date) as day,count(*) as total_transactions,rank() over(partition by branch order by count(*) desc) as rankfrom walmart_clean_datagroup by branch,datename(weekday,date)) as t2where rank=1--4. Calculate Total Quantity Sold by Payment Methodselect payment_method,sum(quantity) as total_qtyfrom walmart_clean_datagroup by payment_method--Q5.--Determine the average,minimum, and maximum rating of category for each city-- List the city,avg_rating,min_rating,max_ratingselect*from walmart_clean_dataselect city,       category,	   avg(rating) as avg_rating,	   min(rating) as min_rating,	   max(rating) as max_ratingfrom walmart_clean_datagroup by city,category--Q6.--Calculate Total Profit by Categoryselect category,sum(total)as revenue,sum((profit_margin)*(total)) as total_profitfrom walmart_clean_datagroup by category--Q7-- Determine the Most Common Payment Method per Branchselect*from(select branch,payment_method,count(*) as no_of_payments,rank() over(partition by branch order by count(*)desc) as rank from walmart_clean_datagroup by branch,payment_method) as t4where rank=--Q8--Analyze Sales Shifts Throughout the Day--categorize sales into 3 groups morning,afternoon,evening--Find out which of the shift has most number of invoicesselect branch,       case 	      when datepart(hour,time)<12 then 'Morning'		  when datepart(hour,time) between 12 and 17 then 'Afternoon'	      else 'Evening'	   end as day_time,	   count(*) as total_invoicesfrom walmart_clean_datagroup by branch,case 					when datepart(hour,time)<12 then 'Morning'					when datepart(hour,time) between 12 and 17 then 'Afternoon'					else 'Evening'				endorder by branch,count(*) desc--Q9--Identify 5 Branches with Highest Revenue Decline Year-Over-Year(2023 and 2022)select  top 5 ls.branch,       ls.last_revenue as last_year_revenue,	   cs.current_revenue as current_year_revenue,	   round((ls.last_revenue-cs.current_revenue)*100/ls.last_revenue,2) as revenue_decline_yoyfrom (		select branch,			   sum(total) as last_revenue		from walmart_clean_data		where year(date)=2022		group by branch     ) lsjoin  (		select branch,			   sum(total) as current_revenue		from walmart_clean_data		where year(date)=2023		group by branch		) cson  ls.branch=cs.branchwhere ls.last_revenue>cs.current_revenueorder by (ls.last_revenue-cs.current_revenue)*100/ls.last_revenue desc