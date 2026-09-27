SELECT o.order_id,c.customer_name,o.sales 
FROM orders o 
JOIN customers c
ON o.customer_id = c.customer_id
WHERE sales > 500
ORDER BY o.sales DESC;

SELECT o.order_id,c.customer_name,p.category,o.sales
FROM orders o 
JOIN customers c
ON o.customer_id = c.customer_id
JOIN products p
ON o.product_id = p.product_id;

SELECT c.region, COALESCE(SUM(o.sales), 0)
FROM orders o
FULL OUTER JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.region;

SELECT p.product_name, COALESCE(SUM(o.sales), 0)
FROM orders o
RIGHT JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY product_name;

SELECT c.customer_name,o.order_id,o.sales
FROM orders o
FULL OUTER JOIN customers c
ON o.customer_id = c.customer_id;

SELECT c.region, SUM(o.sales)
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.region;

SELECT c.customer_name, COUNT (o.order_id)
FROM orders o
FULL OUTER JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name;

SELECT p.sub_category, AVG(o.discount)
FROM orders o
FULL OUTER JOIN products p
ON o.product_id = p.product_id
GROUP BY p.sub_category;

SELECT c.customer_name, SUM (o.sales) AS suma
FROM orders o
FULL OUTER JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name
HAVING SUM(o.sales) > 2000;

SELECT c.region, SUM(o.sales), AVG(o.discount),COUNT(o.order_id)
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.region;

SELECT c.region, 
COUNT(CASE WHEN o.sales > 1000 then 1 END) as high_value, 
COUNT (CASE WHEN o.sales <= 1000 then 1 END) as low_value
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.region;

SELECT c.customer_name, SUM(o.sales), AVG(o.discount),COUNT(o.order_id),
CASE 
    WHEN SUM(o.sales) > 2500 THEN 'VIP'
    ELSE 'REGULAR'
END
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY SUM(o.sales) DESC;