-- Active: 1790434818102@@127.0.0.1@5432@datacarftinglab_db
CREATE TABLE flourmills_sales (
    sales_id INT PRIMARY KEY,
    sale_date DATE,
    region VARCHAR(100),
    states VARCHAR(100),
    product_category VARCHAR(100),
    product_name VARCHAR(150),
    customer_type VARCHAR(100),
    customer_id INT,
    quantity_sold INT,
    unit_price numeric(10,2),
    discount_rate INT,
    payment_method VARCHAR(100),
    sales_rep VARCHAR(150),
    warehouse VARCHAR(100),
    delivery_status VARCHAR(100),
    order_chanell VARCHAR(100),
    batch_number INT,
    production_date DATE,
    total_amount numeric(10,2)
);

SELECT * FROM flourmills_sales;