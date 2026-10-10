-- Active: 1790434818102@@127.0.0.1@5432@retail_sales
CREATE OR REPLACE PROCEDURE get_customer_sales(
    IN p_customer_id VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
DECLARE
    total_sales NUMERIC(10,2);
BEGIN
    SELECT COALESCE(SUM(sales), 0)
    INTO total_sales
    FROM orders
    WHERE customer_id = p_customer_id;

    RAISE NOTICE 'Customer ID: %, Total sales: %',
        p_customer_id, total_sales;
END;
$$;

CALL get_customer_sales('C001');



CREATE OR REPLACE PROCEDURE apply_regional_discount(
    IN region_name VARCHAR(50),
    IN discount_rate NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE orders
    SET sales = sales * (1 - discount_rate)
    WHERE region = region_name;

    RAISE NOTICE 'Discount of % applied to region %',
        discount_rate, region_name;
END;
$$;

CALL apply_regional_discount('West', 0.10);


CREATE OR REPLACE PROCEDURE get_sales_between(
    IN start_date DATE,
    IN end_date DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    total_sales NUMERIC(12,2);
BEGIN
    SELECT COALESCE(SUM(sales), 0)
    INTO total_sales
    FROM orders
    WHERE order_date BETWEEN start_date AND end_date;

    RAISE NOTICE 'Period: % to %, Total sales: %',
        start_date, end_date, total_sales;
END;
$$;

CALL get_sales_between('2024-01-01', '2024-03-31');