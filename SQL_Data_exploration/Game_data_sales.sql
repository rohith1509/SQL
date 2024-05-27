select * from Game_sales_data;

Select Platform, Sum(Global_Sales) total_sales from Game_sales_data group by Platform order by total_sales desc;

Select Publisher, Sum(Global_Sales) total_sales from Game_sales_data group by Publisher order by total_sales desc;

Select Year, Sum(Global_Sales) total_sales from Game_sales_data group by Year order by total_sales desc;

Select Genre, Sum(Global_Sales) total_sales from Game_sales_data group by Genre order by total_sales desc;

Select genre,year,global_sales, Rank() over (partition by year order by global_sales desc) Rank from Game_sales_data where year is not null order by year desc;

select name, NA_Sales from Game_sales_data order by NA_Sales desc;
select name, JP_Sales from Game_sales_data order by JP_Sales desc;