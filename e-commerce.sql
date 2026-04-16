create database E_commerce_database;
use E_commerce_database;

create table customers(customer_id varchar(50) primary key, unique_customer_id varchar(50), customer_zipcode int(6), customer_city varchar(50), customer_state varchar(50));
alter table customers modify customer_zipcode varchar(10);
load data local infile 'C:\Users\Aayush\Desktop\SQL\datasets\olist_customers_dataset.csv'
into table customers fields terminated by ',' ignore 1 rows;

create table orders(order_id varchar(50) primary key, customer_id varchar(50), order_status varchar(20), order_purchase_time timestamp, order_apporved_time timestamp,
order_carrier_date timestamp, order_customer_date timestamp, order_estimated_date timestamp, foreign key 
(customer_id) references customers(customer_id));
load data local infile 'C:\Users\Aayush\Desktop\SQL\datasets\olist_orders_dataset.csv'
into table orders fields terminated by ',' ignore 1 rows;

create table order_items(order_id varchar(50), order_item_id int, product_id varchar(50), seller_id varchar(50), shipping_time timestamp, 
price decimal(12,2), freight_value decimal(12,2),
primary key(order_id, order_item_id),
foreign key (order_id) references orders(order_id));
load data local infile 'C:\Users\Aayush\Desktop\SQL\datasets\olist_order_items_dataset.csv'
into table order_items fields terminated by ',' ignore 1 rows;

create table products(product_id varchar(50) primary key, category varchar(50), product_name_length int, product_description_length int, product_photos_quantity int, 
product_weight int, product_length int, product_height int, prodcut_width int);
load data local infile 'C:\Users\Aayush\Desktop\SQL\datasets\olist_products_dataset.csv'
into table products fields terminated by ',' ignore 1 rows;

-- ==============================
-- 1. Data Exploration
-- ==============================
SELECT * FROM orders LIMIT 10;
SELECT COUNT(*) AS total_orders
FROM orders;

-- ==============================
-- 2. Orders by Status
-- ==============================
SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- ==============================
-- 3. Orders Over Time
-- ==============================
SELECT 
    MONTH(order_purchase_time) AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;

-- ==============================
-- 4. Daily Order Volume
-- ==============================
SELECT 
    DATE(order_purchase_time) AS order_date,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_date
ORDER BY order_date;

-- ==============================
-- 5. Order Processing Time
-- ==============================
SELECT 
    AVG(TIMESTAMPDIFF(HOUR, order_purchase_time, order_apporved_time)) AS avg_approval_time_hours
FROM orders
WHERE order_apporved_time IS NOT NULL;

-- ==============================
-- 6. Delivery Time Analysis
-- ==============================
SELECT 
    AVG(TIMESTAMPDIFF(DAY, order_purchase_time, order_customer_date)) AS avg_delivery_days
FROM orders
WHERE order_customer_date IS NOT NULL;

-- ==============================
-- 7. Late Deliveries
-- ==============================
SELECT 
    COUNT(*) AS late_orders
FROM orders
WHERE order_customer_date > order_estimated_date;
