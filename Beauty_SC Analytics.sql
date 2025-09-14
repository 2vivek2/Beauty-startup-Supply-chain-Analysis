create database Supply_chain;

select * from supply_chain_data;

-- Types of product has been sold and their quantity

select `Product type`, count(1) as total_quantity_sold
from supply_chain_data 
group by `Product type`;

-- total Sales of the product_type 

SELECT 
  `Product type`,
  concat('₹', ' ',  SUM(price * `Number of products sold`)) AS total_sales
FROM supply_chain_data
GROUP BY `Product type`;

-- number of products sold per category
    
 select `Product type`, 
        sum(`Number of products sold`) as total_product_sold
        from supply_chain_data
        group by `Product type`;
        
-- customer segmentation by Product type

select 
      `Product type`,
      `Customer demographics`,
      count(*) as cnt
      from supply_chain_data
      group by `Product type`, `Customer demographics`
      order by `Product type`, count(*) desc;

-- Who buys the most by gender

select `Customer demographics`,
       count(1) as cnt
       from supply_chain_data
       group by `Customer demographics`;
       
-- stocks level per product by location

select 
      `Product type`,
      Location,
      sum(`Stock levels`) as total_stock_per_loc
      from supply_chain_data
      group by  `Product type`, Location
	  order by `Product type`, sum(`Stock levels`) desc;

       
-- shipping time based on product and location

WITH shipping_agg AS (
  SELECT 
    `Product type`,
    Location,
    ROUND(AVG(`Shipping times`), 0) AS avg_ship_time
  FROM supply_chain_data
  GROUP BY `Product type`, Location
)
SELECT 
  *,
  case 
      when avg_ship_time > AVG(avg_ship_time) OVER (PARTITION BY `Product type`) then 'Delayed Delivery' else 'On Time' end as del_flag 
FROM shipping_agg
ORDER BY `Product type`, avg_ship_time;

-- shipping time based on shipping carriers and suppliers

WITH cte AS (
  SELECT 
    `Shipping carriers`,
    `Supplier name`,
    AVG(`Shipping times`) AS avg_ship_carriers
  FROM supply_chain_data
  GROUP BY `Shipping carriers`, `Supplier name`
), delayed_supplier as (SELECT 
  *,
  AVG(avg_ship_carriers) OVER (PARTITION BY `Shipping carriers`) AS avgs,
  case 
      when avg_ship_carriers < AVG(avg_ship_carriers) OVER (PARTITION BY `Shipping carriers`) 
      then 'On Time Supplier' else 'Delayed Del. Supplier' end as del_flag
FROM cte
ORDER BY `Shipping carriers`, avg_ship_carriers)
select * from delayed_supplier
where del_flag = 'Delayed Del. Supplier';

-- total_order placed by product

select `Product type`,
       sum(`Order quantities`) as total_order
       from supply_chain_data
       group by  `Product type`;

-- inspection results based on each product

select `Product type`,
        `Inspection results`,
        count(*) as cnt 
        from supply_chain_data
        group by `Product type`, `Inspection results`
        order by `Product type`;

-- defect rate by product

select `Product type`,
       avg(`Defect rates`) as avg_defects
       from supply_chain_data
       group by `Product type`;

-- count of transports method and total price took per route

select 
      `Transportation modes`,
      `Routes`,
      count(1) as del_per_transport,
      sum(Costs) as total_cost
      from supply_chain_data
      group by `Transportation modes`,`Routes`
      order by `Transportation modes`;










      
      
