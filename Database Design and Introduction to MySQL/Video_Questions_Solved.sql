SET SQL_SAFE_UPDATES = 0;


-- Module: Database Design and Introduction to SQL
-- Session: Database Creation in MySQL Workbench
-- DDL Statements

-- 1. Create a table 'shipping_mode_dimen' having columns with their respective data types as the following:
--    (i) Ship_Mode VARCHAR(25)
--    (ii) Vehicle_Company VARCHAR(25)
--    (iii) Toll_Required BOOLEAN
create table shipping_mode_dimen (
	Ship_Mode varchar(25),
    Vehicle_Company varchar(25),
    Toll_Required boolean
);

-- 2. Make 'Ship_Mode' as the primary key in the above table.
alter table shipping_mode_dimen
add constraint primary key (Ship_Mode);


-- -----------------------------------------------------------------------------------------------------------------
-- DML Statements

-- 1. Insert two rows in the table created above having the row-wise values:
--    (i)'DELIVERY TRUCK', 'Ashok Leyland', false
--    (ii)'REGULAR AIR', 'Air India', false
insert into shipping_mode_dimen
values
	('DELIVERY TRUCK', 'Ashok Leyland', false),
    ('REGULAR AIR', 'Air India', false);
    
insert into shipping_mode_dimen (Ship_Mode, Vehicle_Company, Toll_Required)
values
	('DELIVERY TRUCK', 'Ashok Leyland', false),
    ('REGULAR AIR', 'Air India', false);

-- 2. The above entry has an error as land vehicles do require tolls to be paid. Update the ‘Toll_Required’ attribute
-- to ‘Yes’.
update shipping_mode_dimen
set Toll_Required = true
where Ship_Mode = 'DELIVERY TRUCK';

-- 3. Delete the entry for Air India.
delete
from shipping_mode_dimen
where Vehicle_Company = 'Air India';


-- -----------------------------------------------------------------------------------------------------------------
-- Adding and Deleting Columns

-- 1. Add another column named 'Vehicle_Number' and its data type to the created table. 
alter table shipping_mode_dimen
add Vehicle_Number varchar(20);

-- 2. Update its value to 'MH-05-R1234'.
update shipping_mode_dimen
set Vehicle_Number = 'MH-05-R1234';

-- 3. Delete the created column.
alter table shipping_mode_dimen
drop column Vehicle_Number;


-- -----------------------------------------------------------------------------------------------------------------
-- Changing Column Names and Data Types

-- 1. Change the column name ‘Toll_Required’ to ‘Toll_Amount’. Also, change its data type to integer.
alter table shipping_mode_dimen
change Toll_Required Toll_Amount int;

-- 2. The company decides that this additional table won’t be useful for data analysis. Remove it from the database.
drop table shipping_mode_dimen;


-- -----------------------------------------------------------------------------------------------------------------
-- Session: Querying in SQL
-- Basic SQL Queries

-- 1. Print the entire data of all the customers.
select *
from cust_dimen;

-- 2. List the names of all the customers.
select Customer_Name
from cust_dimen;

-- 3. Print the name of all customers along with their city and state.
select Customer_Name, City, State
from cust_dimen;

-- 4. Print the total number of customers.
select count(*) as Total_Customers
from cust_dimen;

-- 5. How many customers are from West Bengal?
select count(*) as Bengal_Customers
from cust_dimen
where State = 'West Bengal';

-- 6. Print the names of all customers who belong to West Bengal.
select Customer_Name, State
from cust_dimen
where State = 'West Bengal';


-- -----------------------------------------------------------------------------------------------------------------
-- Operators

-- 1. Print the names of all customers who are either corporate or belong to Mumbai.
select Customer_Name, City, Customer_Segment
from cust_dimen
where City = 'Mumbai' or Customer_Segment = 'Corporate';

-- 2. Print the names of all corporate customers from Mumbai.
select Customer_Name, City, Customer_Segment
from cust_dimen
where City = 'Mumbai' and Customer_Segment = 'Corporate';

-- 3. List the details of all the customers from southern India: namely Tamil Nadu, Karnataka, Telangana and Kerala.
select *
from cust_dimen
where State in ('Tamil Nadu', 'Karnataka', 'Telangana', 'Kerala');

-- 4. Print the details of all non-small-business customers.
select *
from cust_dimen
where Customer_Segment != 'Small Business'; 

-- 5. List the order ids of all those orders which caused losses.
select Ord_id, Profit
from market_fact_full
where profit < 0;

-- 6. List the orders with '_5' in their order ids and shipping costs between 10 and 15.
select Ord_id, Shipping_Cost
from market_fact_full
where Ord_id like '%\_5%' and Shipping_Cost between 10 and 15;


-- -----------------------------------------------------------------------------------------------------------------
-- Aggregate Functions

-- 1. Find the total number of sales made.
select count(sales) as No_Of_Sales
from market_fact_full;

-- 2. What are the total numbers of customers from each city?
select count(Customer_Name) as City_Wise_Customers, City
from cust_dimen
group by City;

-- 3. Find the number of orders which have been sold at a loss.
select count(Ord_id) as Loss_Count
from market_fact_full
where Profit < 0;

-- 4. Find the total number of customers from Bihar in each segment.
select count(Customer_Name) as Segment_Wise_Customers, Customer_Segment
from cust_dimen
where State = 'Bihar'
group by Customer_Segment;

-- 5. Find the customers who incurred a shipping cost of more than 50.
select Cust_id, sum(Shipping_Cost) as Customer_Wise_Shipping_Cost
from market_fact_full
group by Cust_id
having Customer_Wise_Shipping_Cost > 50;


-- -----------------------------------------------------------------------------------------------------------------
-- Ordering

-- 1. List the customer names in alphabetical order.
select Customer_Name
from cust_dimen
order by Customer_Name;

-- 2. Print the three most ordered products.
select Prod_id, sum(Order_Quantity) as Product_Wise_Order_Quantity
from market_fact_full
group by Prod_id
order by Product_Wise_Order_Quantity desc
limit 3;

-- 3. Print the three least ordered products.
select Prod_id, sum(Order_Quantity) as Product_Wise_Order_Quantity
from market_fact_full
group by Prod_id
order by Product_Wise_Order_Quantity
limit 3;

-- 4. Find the sales made by the five most profitable products.
select Prod_id, sum(Profit) as Product_Wise_Profit, round(sum(Sales)) as Rounded_Sales_Amount,
format(round(sum(Sales)), 0, 'en_IN') as Sales_Amount_Indian_Format
from market_fact_full
group by Prod_id
order by Product_Wise_Profit desc
limit 5;

-- 5. Arrange the order ids in the order of their recency.
select Ord_id, Order_Date
from orders_dimen
order by Order_Date desc;

-- 6. Arrange all consumers from Coimbatore in alphabetical order.
select Customer_Name, City, Customer_Segment
from cust_dimen
where City = 'Coimbatore' and Customer_Segment = 'Consumer'
order by Customer_Name;


-- -----------------------------------------------------------------------------------------------------------------
-- String and date-time functions

-- 1. Print the customer names in proper case.
select Customer_Name, concat(upper(substring(substring_index(lower(customer_name), ' ', 1), 1, 1)),
	substring(substring_index(lower(customer_name), ' ' , 1), 2, 20), ' ',
	upper(substring(substring_index(lower(customer_name), ' ', -1), 1, 1)),
    substring(substring_index(lower(customer_name), ' ', -1), 2, 20)) as Customer_Name_Proper_Case
from cust_dimen;

-- 2. Print the product names in the following format: Category_Subcategory.
select Product_Category, Product_Sub_Category,
concat(Product_Category, '_', Product_Sub_Category) as Product_Name
from prod_dimen;

-- 3. In which month were the most orders shipped?
select count(Ship_id) as Ship_Count, month(Ship_Date) as Ship_Month
from shipping_dimen
group by Ship_Month
order by Ship_Count desc
limit 1;

-- 4. Which month and year combination saw the most number of critical orders?
select count(Ord_id) as Order_Count, month(Order_Date) as Order_Month, year(Order_Date) as Order_Year
from orders_dimen
where Order_Priority = 'Critical'
group by Order_Month, Order_Year
order by Order_Count desc
limit 1;

-- 5. Find the most commonly used mode of shipment in 2011.
select Ship_Mode, count(Ship_Mode) as Ship_Mode_Count
from shipping_dimen
where year(Ship_Date) = 2011
group by Ship_Mode
order by Ship_Mode_Count desc
limit 1;


-- -----------------------------------------------------------------------------------------------------------------
-- Regular Expressions

-- 1. Find the names of all customers having the substring 'car'.
select Customer_Name
from cust_dimen
where Customer_Name regexp 'car';

-- 2. Print customer names starting with A, B, C or D and ending with 'er'.
select Customer_Name
from cust_dimen
where Customer_Name regexp '^[abcd].*er$'
order by Customer_Name;


-- -----------------------------------------------------------------------------------------------------------------
-- Nested Queries

-- 1. Print the order number of the most valuable order by sales.
select Ord_id, round(Sales) as Rounded_Sales
from market_fact_full
where Sales = (
	select max(Sales)
    from market_fact_full
);

-- 2. Return the product categories and subcategories of all the products which don’t have details about the product
-- base margin.
select *
from prod_dimen
where Prod_id in (
	select Prod_id
    from market_fact_full
    where Product_Base_Margin is null
);

-- 3. Print the name of the most frequent customer.
select Customer_Name, Cust_id
from cust_dimen
where Cust_id = (
    select Cust_id
    from market_fact_full
    group by Cust_id
    order by count(Cust_id) desc
    limit 1
);

-- 4. Print the three most common products.
select Product_Category, Product_Sub_Category
from prod_dimen
where Prod_id in (
	select Prod_id
	from market_fact_full
	group by Prod_id
	order by count(Prod_id) desc
)
limit 3;


-- -----------------------------------------------------------------------------------------------------------------
-- CTEs

-- 1. Find the 5 products which resulted in the least losses. Which product had the highest product base
-- margin among these?
select Prod_id, Profit, Product_Base_Margin
from market_fact_full
where Profit < 0
order by Profit desc
limit 5;

with least_losses as (
	select Prod_id, Profit, Product_Base_Margin
    from market_fact_full
    where Profit < 0
    order by Profit desc
    limit 5
) select *
  from least_losses
  where Product_Base_Margin = (
	select max(Product_Base_Margin)
    from least_losses
  );

-- 2. Find all low-priority orders made in the month of April. Out of them, how many were made in the first half of
-- the month?
select Ord_id, Order_Date, Order_Priority
from orders_dimen
where Order_Priority = 'low' and month(Order_Date) = 4;

with low_priority_orders as (
	select Ord_id, Order_Date, Order_Priority
    from orders_dimen
    where Order_Priority = 'low' and month(Order_Date) = 4
) select count(Ord_id) as Order_Count
  from low_priority_orders
  where day(Order_Date) between 1 and 15;


-- -----------------------------------------------------------------------------------------------------------------
-- Views

-- 1. Create a view to display the sales amounts, the number of orders, profits made and the shipping costs of all
-- orders. Query it to return all orders which have a profit of greater than 1000.
create view order_info
as select Ord_id, Sales, Order_Quantity, Profit, Shipping_Cost
   from market_fact_full;

select Ord_id, Profit
from order_info
where Profit > 1000;

-- 2. Which year generated the highest profit?
create view market_facts_and_orders
as select *
   from market_fact_full
   inner join orders_dimen
   using (Ord_id);

select sum(Profit) as Year_Wise_Profit, year(Order_Date) as Order_Year
from market_facts_and_orders
group by Order_Year
order by Year_Wise_Profit desc
limit 1;


-- -----------------------------------------------------------------------------------------------------------------
-- Session: Joins and Set Operations
-- Inner Join

-- 1. Print the product categories and subcategories along with the profits made for each order.
select Ord_id, Product_Category, Product_Sub_Category, Profit
from prod_dimen p
inner join market_fact_full m
on p.Prod_id = m.Prod_id;

-- 2. Find the shipment date, mode and profit made for every single order.
select Ord_id, Profit, Ship_Mode
from market_fact_full m
inner join shipping_dimen s
on m.Ship_id = s.Ship_id;

-- 3. Print the shipment mode, profit made and product category for each product.
select p.Prod_id, Profit, Product_Category, Ship_Mode
from prod_dimen p
inner join market_fact_full m
on p.prod_id = m.prod_id
inner join shipping_dimen s
on m.ship_id = s.ship_id;

-- 4. Which customer ordered the most number of products?
select Customer_Name, sum(Order_Quantity) as Total_Orders
from cust_dimen c
inner join market_fact_full m
on c.Cust_id = m.Cust_id
group by Customer_Name
order by Total_Orders desc;

-- alternate way
select Customer_Name, sum(Order_Quantity) as Total_Orders
from cust_dimen
inner join market_fact_full
using (Cust_id)
group by Customer_Name
order by Total_Orders desc;

-- 5. Selling office supplies was more profitable in Delhi as compared to Patna. True or false?
select City, sum(Profit) as City_Wise_Profit
from prod_dimen p
inner join market_fact_full m
on p.Prod_id = m.Prod_id
inner join cust_dimen c
on m.Cust_id = c.Cust_id
where Product_Category = 'Office Supplies' and City in ('Delhi', 'Patna')
group by City;

-- 6. Print the name of the customer with the maximum number of orders.
select Customer_Name, sum(Order_Quantity) as No_Of_Orders
from cust_dimen c
inner join market_fact_full m
on c.cust_id = m.cust_id
group by Customer_Name
order by No_Of_Orders desc
limit 1;

-- 7. Print the three most common products.
select Product_Sub_Category, Order_Quantity
from prod_dimen p
inner join market_fact_full m
on p.Prod_id = m.Prod_id
group by Product_Sub_Category
order by Order_Quantity desc
limit 3;


-- -----------------------------------------------------------------------------------------------------------------
-- Outer Join

-- 1. Return the order ids which are present in the market facts table.
select Ord_id
from orders_dimen
left join market_fact_full
using (Ord_id)
group by Ord_id
order by Ord_id;

select Ord_id
from market_fact_full
right join orders_dimen
using (Ord_id)
group by Ord_id
order by Ord_id;

-- Execute the below queries before solving the next question.
create table manu (
	Manu_Id int primary key,
	Manu_Name varchar(30),
	Manu_City varchar(30)
);

insert into manu values
(1, 'Navneet', 'Ahemdabad'),
(2, 'Wipro', 'Hyderabad'),
(3, 'Furlanco', 'Mumbai');

alter table Prod_Dimen
add column Manu_Id int;

update Prod_Dimen
set Manu_Id = 2
where Product_Category = 'technology';

-- 2. Display the products sold by all the manufacturers using both inner and outer joins.
select Manu_Name, p.Prod_Id
from manu m
inner join prod_dimen p
on m.Manu_Id = p.Manu_Id;

select Manu_Name, p.Prod_Id
from manu m
left join prod_dimen p
on m.Manu_Id = p.Manu_Id;

-- 3. Display the number of products sold by each manufacturer.
select Manu_Name, count(Prod_Id) as Products_Per_Manufacturer
from manu m
inner join prod_dimen p
on m.Manu_Id = p.Manu_Id
group by m.Manu_Name;

select Manu_Name, count(Prod_Id) as Products_Per_Manufacturer
from manu m
left join prod_dimen p
on m.Manu_Id = p.Manu_Id
group by Manu_Name;

-- 4. Create a view to display the customer names, segments, sales, product categories and
-- subcategories of all orders. Use it to print the names and segments of those customers who ordered more than 20
-- pens and art supplies products.
create view order_details
as select Customer_Name, Customer_Segment, Sales, Order_Quantity, Product_Category, Product_Sub_Category
   from cust_dimen c
   inner join market_fact_full m
   on c.Cust_id = m.Cust_id
   inner join prod_dimen p
   on m.Prod_id = p.Prod_id;
   
select Customer_Name, Customer_Segment, Order_Quantity, Product_Sub_Category
from order_details
where Order_Quantity > 20 and Product_Sub_Category = 'Pens & Art Supplies'
group by Customer_Name;


-- -----------------------------------------------------------------------------------------------------------------
-- Union, Union all, Intersect and Minus

-- 1. Combine the order numbers for orders and order ids for all shipments in a single column.
select Order_Number
from orders_dimen
union all
select Order_ID
from shipping_dimen;

-- 2. Return non-duplicate order numbers from the orders and shipping tables in a single column.
select Order_Number
from orders_dimen
union
select Order_ID
from shipping_dimen;

-- 3. Find the shipment details of products with no information on the product base margin.
select s.Ship_id, Order_id, Ship_Mode, Ship_Date
from shipping_dimen s
left join market_fact_full m
on s.Ship_id = m.Ship_id
where Product_Base_Margin is null;

-- 4. What are the two most and the two least profitable products?
(select Prod_id, sum(Profit)
from market_fact_full
group by Prod_id
order by sum(Profit) desc
limit 2)
union
(select Prod_id, sum(Profit)
from market_fact_full
group by Prod_id
order by sum(Profit)
limit 2);