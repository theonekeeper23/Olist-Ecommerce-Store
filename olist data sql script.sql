create database olist;
use  olist;
select * from olist_customers_dataset;
describe olist_customers_dataset;

select * from olist_order_payments_dataset;
describe olist_order_payments_dataset;


select * from olist_order_items_dataset;
describe olist_order_items_dataset;


select * from olist_order_reviews_dataset;
describe olist_order_reviews_dataset;

select * from olist_orders_dataset;
describe olist_orders_dataset;

select * from olist_sellers_dataset;
describe olist_sellers_dataset;

select * from product_category_name_translati;
describe product_category_name_translati;

select count(order_id) from olist_order_items_dataset;
select 
(select round(sum(p.payment_value),0)
from olist_orders_dataset o inner join olist_order_payments_dataset p using(order_id) where  o.order_status="delivered") as Weekend_count,
(select round(sum(p.payment_value),0)
from  olist_orders_dataset o inner join olist_order_payments_dataset p using(order_id) where o.order_status="canceled") as Weekday_count;

select * from olist_orders_dataset;
describe olist_orders_dataset;


select 
(select round(sum(p.payment_value),0)
from olist_orders_dataset o inner join olist_order_payments_dataset p using(order_id) where  o.Weekend_Weekday="Weekend") as Weekend_count,
(select round(sum(p.payment_value),0)
from  olist_orders_dataset o inner join olist_order_payments_dataset p using(order_id) where o.Weekend_Weekday="Weekday") as Weekday_count;


select * from olist_order_reviews_dataset;
select * from olist_order_payments_dataset;

select olist_order_reviews_dataset.review_score, olist_order_payments_dataset.payment_type, count(olist_orders_dataset.order_id) as Total_order
from
olist_orders_dataset
left join
olist_order_reviews_dataset
on
olist_orders_dataset.order_id = olist_order_reviews_dataset.order_id
join
olist_order_payments_dataset
on
olist_orders_dataset.order_id = olist_order_payments_dataset.order_id
group by olist_order_reviews_dataset.review_score, olist_order_payments_dataset.payment_type
having olist_order_reviews_dataset.review_score=5 and olist_order_payments_dataset.payment_type='credit_card';








rename table olist_customers_dataset to customers;
rename table olist_order_items_dataset to items;
rename table olist_order_payments_dataset to payments;
rename table olist_order_reviews_dataset to reviews;
rename table olist_orders_dataset to orders;
rename table olist_products_dataset to products;
rename table olist_sellers_dataset to sellers;
rename table product_category_name_translati to translation;

select * from customers;
select * from items;
select * from payments;
select * from reviews;
select * from orders;
select * from products;
select * from sellers;
select * from translation;

alter table items modify column shipping_limit_date date;
alter table orders modify column order_purchase_timestamp date;
alter table orders modify column order_delivered_customer_date date;
alter table orders modify column order_estimated_delivery_date date ;



#kpi 1 Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

select 
(select round(sum(p.payment_value),0)
from orders o inner join payments p using(order_id) 
where  o.Weekend_Weekday="Weekend") as Weekend_count,
(select round(sum(p.payment_value),0)
from  orders o inner join payments p using(order_id) 
where o.Weekend_Weekday="Weekday") as Weekday_count;



#kpi 2 Number of Orders with review score 5 and payment type as credit card.

select r.review_score, p.payment_type, count(o.order_id) as Total_order
from orders o left join reviews r on o.order_id = r.order_id
join payments p on o.order_id = p.order_id
group by r.review_score, p.payment_type
having r.review_score=5 and p.payment_type='credit_card';


#kpi 3 Average number of days taken for order_delivered_customer_date for pet_shop

select product_category_name,
round(avg(datediff(order_delivered_customer_date , order_purchase_timestamp))) as AVG_Delivery_Days
from orders o  join items  i on i.order_id = o.order_id 
join products p on p.product_id = i.product_id 
where p.product_category_name = 'pet_shop'and o.order_delivered_customer_date is not null;

 
#kpi 4 Average price and payment values from customers of sao paulo city

select round(avg(items.price)) as AVERAGE_PRICE
from  customers join orders on customers.customer_id =orders.customer_id
join items on orders.order_id = items.order_id
where customers.customer_city = 'Sao Paulo';
select round(avg(payments.payment_value))as PAYMENT_VALUE
from  customers join orders on customers.customer_id =orders.customer_id
join payments on orders.order_id = payments.order_id
where customers.customer_city = 'Sao Paulo';


# 5 kpi Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

select round(avg(datediff(order_delivered_customer_date , order_purchase_timestamp)),0) as AVG_SHIPPING_DAYS,
review_score
from orders o join reviews r on o.order_id = r.order_id
where order_delivered_customer_date is not null
and order_purchase_timestamp is not null
group by review_score;




