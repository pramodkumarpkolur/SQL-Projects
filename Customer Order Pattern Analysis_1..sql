#SQL Project 1

#Customer Order Pattern Analysis
insert into dspro.swiggy
values
(1, "SW1005", 700, 50, "KFC", 753, "2021-10-10", "Door locked"),
(2, "SW1006", 710, 59, "Pizza hut", 1496, "2021-09-01", "In-time delivery"),
(3, "SW1005", 720, 59, "Dominos", 990, "2021-12-10", "  "),
(4, "SW1005", 707, 50, "Pizza hut", 2475, "2021-12-11", "  "),
(5, "SW1006", 770, 59, "KFC", 1250, "2021-11-17", "No response"),
(6, "SW1020", 1000, 119, "Pizza hut", 1400, "2021-11-18", "In-time delivery"),
(7, "SW2035", 1079, 135, "Dominos", 1750, "2021-11-19", "  "),
(8, "SW1020", 1083, 59, "KFC", 1250, "2021-11-20", "  "),
(11, "SW1020", 1100, 150, "Pizza hut", 1950, "2021-12-24", "Late delivery"),
(9, "SW2035", 1095, 119, "Pizza hut", 1270, "2021-11-21", "Late delivery"),
(10, "SW1005", 729, 135, "KFC", 1000, "2021-09-10", "Delivered"),
(1, "SW1005", 700, 50, "KFC", 753, "2021-10-10", "Door locked"),
(2, "SW1006", 710, 59, "Pizza hut", 1496, "2021-09-01", "In-time delivery"),
(3, "SW1005", 720, 59, "Dominos", 990, "2021-12-10", "  "),
(4, "SW1005", 707, 50, "Pizza hut", 2475, "2021-12-11", "  ");
select * from dspro.swiggy;


#Q1: find the count of duplicate rows in the swiggy table.----------------->

select id, count(id) from dspro.swiggy group by id having count(id)>1; 


#Q2: Remove duplicate records from the table.------------------->

create temporary table dspro.abc as (select distinct id, cust_id, order_id, partner_code, outlet,
  bill_amount, order_date, comments from dspro.swiggy);
select * from dspro.abc;

drop table dspro.swiggy;

create table dspro.swiggy as (select * from dspro.abc);
select * from dspro.swiggy;

drop temporary table dspro.abc;


#Q3:Print records from row number 4 to 9.----------------------->
 select * from dspro.swiggy limit 3,6; 
 

#Q4:Find the latest order placed by customers.Refer to the output. --------------------->
 # (customer id- wise latest orders)

with abcd
as (select cust_id, outlet, order_date, rank() over (partition by cust_id order by order_date desc)
 as rank1 from dspro.swiggy) select * from abcd where rank1 < 2;


#5Q:: Print order_id, partner_code, order_date, comment (No issues in place of null else ------------------>
#comment).

create temporary table dspro.ab as (select order_id, partner_code, order_date, comments from dspro.swiggy);
select * from dspro.ab;
set sql_safe_updates=0;

update dspro.ab
set comments ="No issues" where comments ="  " ;
select * from dspro.ab;


#6: : Print outlet wise order count, cumulative order count, total bill_amount, cumulative 
# bill_amount. Refer to the output below  ---------------------------------->

select * from dspro.swiggy;     #For my reference.

select a.outlet, a.order_count, @cum_order_cnt:= @cum_order_cnt + a.order_count as cumulative_count,
a.total_sale, @cum_bill_amt:= @cum_bill_amt + a.total_sale as cumulative_sale
from
(select outlet, count(order_id) as order_count, sum(bill_amount) as total_sale
from dspro.swiggy group by 1 order by order_count ) a
join
(select @cum_order_cnt:=0, @cum_bill_amt:=0) b;



#7: Print cust_id wise, Outlet wise 'total number of orders'.-----------------------> 

select * from dspro.swiggy;        #For my reference

select
cust_id
,count(case when outlet= "KFC" then order_id end) as KFC
,count(case when outlet= "Dominos" then order_id end) as Dominos
,count(case when outlet= "Pizza hut" then order_id end) as Pizza_hut 
from dspro.swiggy group by cust_id;


#8: Print cust_id wise, Outlet wise 'total sales.-------------------->

select
cust_id
,sum(case when outlet="KFC" then bill_amount end) as KFC
,sum(case when outlet="Dominos" then bill_amount end) as Dominos
,sum(case when outlet="Pizza hut" then bill_amount end) as Pizza_hut
from dspro.swiggy group by cust_id;

#_______________________________________________END__________________________________________________



set sql_safe_updates=0;
update dspro.swiggy 
set bill_amount="0" where bill_amount is null;

set sql_safe_updates=0;
update dspro.swiggy 
set outlet="0" where outlet is null;


select * from dspro.swiggy; 