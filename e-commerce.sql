create database E_commerce_database;
use E_commerce_database;

create table customers(customer_id varchar(50) primary key, unique_customer_id varchar(50), customer_zipcode int(6), customer_city varchar(50), customer_state varchar(50));
alter table customers modify customer_zipcode varchar(10);
load data local infile 'olist_customers_dataset.csv'
into table customers fields terminated by ',' ignore 1 rows;

create table orders(order_id varchar(50) primary key, customer_id varchar(50), order_status varchar(20), order_purchase_time timestamp, order_apporved_time timestamp,
order_carrier_date timestamp, order_customer_date timestamp, order_estimated_date timestamp, foreign key 
(customer_id) references customers(customer_id));
load data local infile 'olist_orders_dataset.csv'
into table orders fields terminated by ',' ignore 1 rows;

create table order_items(order_id varchar(50), order_item_id int, product_id varchar(50), seller_id varchar(50), shipping_time timestamp, 
price decimal(12,2), freight_value decimal(12,2),
primary key(order_id, order_item_id),
foreign key (order_id) references orders(order_id));
load data local infile 'olist_order_items_dataset.csv'
into table order_items fields terminated by ',' ignore 1 rows;

create table products(product_id varchar(50) primary key, category varchar(50), product_name_length int, product_description_length int, product_photos_quantity int, 
product_weight int, product_length int, product_height int, prodcut_width int);
load data local infile 'olist_products_dataset.csv'
into table products fields terminated by ',' ignore 1 rows;

select sum(price) from order_items;

select count(*) as total_orders from orders;

select count(distinct(customer_id)) from customers;

SELECT o.order_id, SUM(oi.price) AS order_revenue
FROM orders o
JOIN order_items oi 
ON o.order_id = oi.order_id
GROUP BY o.order_id;

SELECT o.order_id, SUM(oi.price) AS order_revenue
FROM orders o
JOIN order_items oi 
ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY order_revenue DESC
LIMIT 10;

select p.category, sum(oi.price) as category_revenue
from order_items oi join products p
on oi.product_id = p.product_id
group by p.category
order by category_revenue desc;

SELECT c.customer_id, SUM(oi.price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 10;

SELECT 
DATE_FORMAT(o.order_purchase_time, '%Y-%m') AS month,
SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

SELECT customer_id, COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

SELECT 
    c.customer_id,
    SUM(oi.price) AS total_spent,
    RANK() OVER (ORDER BY SUM(oi.price) DESC) AS c_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id;