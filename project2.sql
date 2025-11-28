use olist;
-- 1st kpi
create table kpi_1 SELECT IFNULL(days, 'Grand Total') AS days,
       TotalPayments
FROM (
  SELECT CASE
           WHEN DAYOFWEEK(o.order_purchase_timestamp) IN (1,7) THEN 'weekends'
           ELSE 'weekdays'
         END AS days,
        concat( "$",'',ROUND(SUM(p.payment_value)/1000000),'M') AS TotalPayments
  FROM olist_data o
  JOIN payments p ON o.order_id = p.order_id
  GROUP BY CASE
             WHEN DAYOFWEEK(o.order_purchase_timestamp) IN (1,7) THEN 'weekends'
             ELSE 'weekdays'
           END WITH ROLLUP
) AS t;



select * from  kpi_5;
-- 2nd kpi
 create  table kpi_2 select CONCAT(ROUND(COUNT(DISTINCT p.order_id) / 1000, 1), 'K') as Number_of_orders
from payments as p 
join review_score as r on p.order_id = r.order_id
where r.review_score = 5 and p.payment_type = 'credit_card';

-- 3rd kpi
create table kpi_3 select product_category_name,round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp))) as Avg_count
from olist_data as o 
join items as i on i.order_id = o.order_id
join products as p on p.product_id = i.product_id
where product_category_name = "pet_shop" and o.order_delivered_customer_date is not null;

-- 4th kpi
create table kpi_4 select c.city as city,round(avg(i.price)) as avg_price ,
round(avg(p.payment_value)) as avg_payment  from customer_l as  c
join olist_data as o on c.customer_id = o.customer_id 
join itmes_l as i on o.order_id = i.order_id 
join payments as  p on o.order_id = p.order_id 
where c.city = 'sao paulo'; 

-- 5th kpi 
create table kpi_5 SELECT IFNULL(review_score, 'Grand Total') AS review_score,
       ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 0) AS avg_shippingdays
FROM olist_data o
JOIN review_score r ON o.order_id = r.order_id
WHERE order_delivered_customer_date IS NOT NULL 
  AND order_purchase_timestamp IS NOT NULL
GROUP BY review_score WITH ROLLUP;

-- TOP 5 STATE BY SALES
 SELECT IFNULL(State, 'Grand Total') AS State, round(SUM(payment_value)) AS SALES  from customer_l as  c
join olist_data as o on c.customer_id = o.customer_id 
join itmes_l as i on o.order_id = i.order_id 
join payments as  p on o.order_id = p.order_id 
group by STATE with rollup order by SALES desc limit 5;

-- BOTTOM 5 STATE BY SALES
select c.State as STATE, round(SUM(payment_value)) AS SALES  from customer_l as  c
join olist_data as o on c.customer_id = o.customer_id 
join itmes_l as i on o.order_id = i.order_id 
join payments as  p on o.order_id = p.order_id 
group by STATE   order by SALES asc limit 5;

-- TOP 5 PRODUCT BY SALES
SELECT IFNULL(P.product_category_name, 'Grand Total') AS PRODUCT,
       ROUND(SUM(PA.payment_value)) AS SALES
FROM PRODUCTS AS P
JOIN itmes_l AS I ON P.product_id = I.product_id
JOIN PAYMENTS_L AS PA ON I.order_id = PA.order_id
GROUP BY P.product_category_name WITH ROLLUP
ORDER BY SALES DESC
LIMIT 5;

-- BOTTOM 5 PRODUCT BY SALES 
select P.product_category_name AS PRODUCT , ROUND(SUM(PA.payment_value)) AS SALES from 
PRODUCTS AS P join itmes_l AS I ON P.product_id = I.product_id 
join PAYMENTS_L AS PA ON I.order_id = PA.order_id
group by PRODUCT  order by SALES asc limit 5;

-- DIFFERENT TYPE OF PAYMENTS METHOD BY SALES
select ifnull(payment_type ,'grand total') as PAYMENTS_METHODs, round(SUM(payment_value)) AS SALES from payments_l
group by  payment_type with rollup  ;
