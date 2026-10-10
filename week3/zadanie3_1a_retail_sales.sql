-- Active: 1790434818102@@127.0.0.1@5432@retail_sales
ALTER DATABASE retail_sales
SET datestyle TO 'ISO, MDY';

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL,
    region VARCHAR(20) NOT NULL,
    category VARCHAR(50) NOT NULL,
    ship_mode VARCHAR(30) NOT NULL,
    sales numeric(10,2) NOT NULL,
    profit numeric(10,2) NOT NULL
);

SELECT *
FROM orders;
