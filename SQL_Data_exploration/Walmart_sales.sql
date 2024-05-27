select * from Walmart_Sales_Data;

select City,sum(Total) as Total_sales_amount from Walmart_Sales_Data
group by city order by Total_sales_amount desc;

select Product_line,sum(Total) as Total_sales_amount from Walmart_Sales_Data
group by Product_line order by Total_sales_amount desc;

select MONTH(date) Month_number,datename(Month,date) as month_name,sum(Total) as Total_sales_amount from Walmart_Sales_Data
group by MONTH(date),datename(Month,date)
order by month_number;

select Payment,count(payment) Payment_count from Walmart_Sales_Data group by Payment
order by Payment desc;

select Customer_type,count(Customer_type) Customer_type_count,sum(total) as total_payments from Walmart_Sales_Data group by Customer_type
order by total_payments desc;

Alter Table Walmart_Sales_Data ADD time_of_day varchar(20);

Update Walmart_Sales_Data set time_of_day =
(case when time between '00:00:00' and '12:00:00' then 'Morning'
when time between '12:00:00' and '16:00:00' then 'Afternoon'
else 'Evening'
end);

Alter Table Walmart_Sales_Data ADD Month_name varchar(20);

Update Walmart_Sales_Data set Month_name = Datename(Month,date)
Alter Table Walmart_Sales_Data ADD day_name varchar(20);

Update Walmart_Sales_Data set day_name = Datename(weekday,date)