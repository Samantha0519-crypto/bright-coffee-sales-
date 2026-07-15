-- Databricks notebook source
select * from `brightlearn`.`data`.`bright_coffee_shop_sales`; --previewing table--

describe table `brightlearn`.`data`.`bright_coffee_shop_sales`; --checking data type--

-- Check for missing values in all columns
SELECT *
FROM `brightlearn`.`data`.`bright_coffee_shop_sales`
WHERE transaction_id IS NULL
   OR transaction_date IS NULL
   OR transaction_time IS NULL
   OR transaction_qty IS NULL
   OR store_location IS NULL
   OR product_category IS NULL
   OR product_type IS NULL
   OR product_detail IS NULL
   OR unit_price IS NULL;

-- counting rows
select count(transaction_id) as row_count
from `brightlearn`.`data`.`bright_coffee_shop_sales`;

--previewing product_id
select distinct product_id 
from `brightlearn`.`data`.`bright_coffee_shop_sales`;

--statistics
select mean(product_id),
       min(product_id),
       max(product_id),
       median(product_id)
from `brightlearn`.`data`.`bright_coffee_shop_sales`;

-- applying aggregation

select median(cast(replace(unit_price, ',', '.') as decimal(10,2)) * cast(transaction_qty as int)) as median,
       max(cast(replace(unit_price, ',', '.') as decimal(10,2)) * cast(transaction_qty as int)) as maximum,
       min(cast(replace(unit_price, ',', '.') as decimal(10,2)) * cast(transaction_qty as int)) as minimum,
       avg(cast(replace(unit_price, ',', '.') as decimal(10,2)) * cast(transaction_qty as int)) as average
from `brightlearn`.`data`.`bright_coffee_shop_sales`;   

---previewing product_category
select distinct product_category
from `brightlearn`.`data`.`bright_coffee_shop_sales`;

---previewing store_location 
select distinct store_location 
from `brightlearn`.`data`.`bright_coffee_shop_sales`;

---previewing product_detail
select distinct product_detail
from `brightlearn`.`data`.`bright_coffee_shop_sales`;

----previewing product_type
select distinct product_type 
from `brightlearn`.`data`.`bright_coffee_shop_sales`;

---extracting purchase_time from timestamp--
select date_format(transaction_time, 'HH:mm:ss') as purchase_time
from `brightlearn`.`data`.`bright_coffee_shop_sales`;

--calculating total revenue--
select product_category,
       product_type, 
       product_detail,
   cast(replace(unit_price, ',', '.') as decimal(10,2)) * cast(transaction_qty as int) as total_revenue
from `brightlearn`.`data`.`bright_coffee_shop_sales`;

-- applying aggregation
select max(cast(replace(unit_price, ',', '.') as decimal(10,2)) * cast(transaction_qty as int)) as maximum,
       min(cast(replace(unit_price, ',', '.') as decimal(10,2)) * cast(transaction_qty as int)) as minimum,
       avg(cast(replace(unit_price, ',', '.') as decimal(10,2)) * cast(transaction_qty as int)) as average,
       sum(cast(replace(unit_price, ',', '.') as decimal(10,2)) * cast(transaction_qty as int)) as total_sales
from `brightlearn`.`data`.`bright_coffee_shop_sales`;

---finding a category with maximum revenue--
select  product_category,
        sum(cast(replace(unit_price, ',', '.') as decimal(10,2)) * cast(transaction_qty as int) )as total_revenue
from `brightlearn`.`data`.`bright_coffee_shop_sales`
   group by product_category order by total_revenue desc;



--full syntax of the new table---
select transaction_id,
       transaction_date,
       transaction_time,
       transaction_qty,
       store_id,
       store_location,
       product_id,
       unit_price,
       product_category,
       product_type, 
       product_detail,
       cast(replace(unit_price, ',', '.') as decimal(10,2)) * cast(transaction_qty as int) as total_revenue, --total revenue---
      date_format(transaction_time, 'HH:mm:ss') as purchase_time, ---extracting time from timestamp--
      case --creating time buckets to identify peak hours---
          when date_format(transaction_time, 'HH:mm:ss') >= '07:00:00' AND  date_format(transaction_time, 'HH:mm:ss') < '12:00:00' THEN 'Morning' 
          when date_format(transaction_time, 'HH:mm:ss') >= '12:00:00' AND date_format(transaction_time, 'HH:mm:ss') < '16:00:00' THEN 'Afternoon'
          when date_format(transaction_time, 'HH:mm:ss') >= '16:00:00' AND date_format(transaction_time, 'HH:mm:ss')<= '19:00:00' THEN 'Evening'
          else 'Outside Business Hours'
          end as day_part,
      case --identifying sales category---
          when cast(replace(unit_price, ',', '.') as decimal(10,2)) * cast(transaction_qty as int) >= 20.0 then 'large sale'
          when cast(replace(unit_price, ',', '.') as decimal(10,2)) * cast(transaction_qty as int) between 3.75 and 20.0 then 'medium sale'
          else 'small sale'
          end as sale_category
from `brightlearn`.`data`.`bright_coffee_shop_sales`; 
