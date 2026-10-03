SELECT product_name, total_amount
FROM flourmills_sales
WHERE total_amount >
(SELECT AVG(total_amount) FROM flourmills_sales);


SELECT sales_id, sale_date, region, product_category
FROM flourmills_sales
WHERE product_category = (
    SELECT product_category
    FROM flourmills_sales
    GROUP BY product_category
    ORDER BY SUM(total_amount) DESC
    LIMIT 1
);


SELECT product_name, total_amount, avg(total_amount) OVER () as avg_amount
FROM flourmills_sales;


SELECT product_name, total_amount, total_amount / (
        SELECT SUM(total_amount)
        FROM flourmills_sales
    ) * 100 AS amount_share
FROM flourmills_sales
;


SELECT
    months,
    SUM(total_amount) AS monthly_sales
FROM (
    SELECT
        EXTRACT(MONTH FROM sale_date) AS months,
        total_amount
    FROM flourmills_sales
) AS monthly_data
GROUP BY months
ORDER BY months;


SELECT
    product_category,
    category_total,
    SUM(category_total) OVER () AS sum_amount
FROM (
    SELECT
        product_category,
        SUM(total_amount) AS category_total
    FROM flourmills_sales
    GROUP BY product_category
    HAVING SUM(total_amount) > 50000000
) AS category_sales;


SELECT
    product_name,
    product_category,
    total_amount
FROM flourmills_sales f
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM flourmills_sales
    WHERE product_category = f.product_category
);


SELECT
    product_name,
    region,
    total_amount,
    (
        SELECT MIN(f2.total_amount)
        FROM flourmills_sales f2
        WHERE f2.region = f1.region
    ) AS region_min_amount
FROM flourmills_sales f1;


SELECT
    product_name,
    sale_date,
    total_amount
FROM flourmills_sales f
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.product_name = f.product_name
      AND EXTRACT(MONTH FROM f2.sale_date) <> EXTRACT(MONTH FROM f.sale_date)
);


SELECT product_category, product_name, total_amount
FROM flourmills_sales t1
WHERE EXISTS(
    SELECT 1
    from flourmills_sales t2
    WHERE t2.product_category = t1.product_category
    AND total_amount > 200000
);

SELECT DISTINCT
    product_category
FROM flourmills_sales f
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.product_category = f.product_category
    GROUP BY f2.product_category
    HAVING COUNT(DISTINCT f2.region) > 2
);


SELECT
    product_name,
    sale_date,
    region
FROM flourmills_sales f
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.region = f.region
      AND EXTRACT(YEAR FROM f2.sale_date) = 2024
    GROUP BY region
);


SELECT DISTINCT product_category, total_amount
FROM flourmills_sales t1
WHERE NOT EXISTS (
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.product_category = t1.product_category
      AND t2.total_amount > 500000
);


SELECT DISTINCT region
FROM flourmills_sales t1
WHERE NOT EXISTS (
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.region = t1.region
      AND t2.product_category = 'Flour'
); 