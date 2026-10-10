-- Active: 1790434818102@@127.0.0.1@5432@datacarftinglab_db
WITH daily_sales AS (
    SELECT
        sale_date,
        SUM(total_amount) AS total_daily_sales
    FROM flourmills_sales
    GROUP BY sale_date
)
SELECT
    sale_date,
    total_daily_sales
FROM daily_sales
WHERE total_daily_sales > 3000000
ORDER BY total_daily_sales DESC;


WITH category_sales AS (
    SELECT
        product_category,
        SUM(total_amount) AS total_sales
    FROM flourmills_sales
    GROUP BY product_category
)
SELECT
    product_category,
    total_sales
FROM category_sales
ORDER BY total_sales DESC;


WITH product_sales AS (
    SELECT
        product_category,
        product_name,
        SUM(total_amount) AS total_product_sales
    FROM flourmills_sales
    GROUP BY
        product_category,
        product_name
),
ranked_products AS (
    SELECT
        product_category,
        product_name,
        total_product_sales,
        RANK() OVER (
            PARTITION BY product_category
            ORDER BY total_product_sales DESC
        ) AS category_rank
    FROM product_sales
)
SELECT
    product_category,
    product_name,
    total_product_sales,
    category_rank
FROM ranked_products
WHERE category_rank <= 3
ORDER BY
    product_category,
    category_rank;


WITH customer_type_sales AS (
    SELECT
        customer_type,
        SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY customer_type
),
revenue_analysis AS (
    SELECT
        customer_type,
        revenue,
        SUM(revenue) OVER () AS total_revenue,
        ROUND(
            (revenue * 100.0 / NULLIF(SUM(revenue) OVER (), 0))::NUMERIC,
            2
        ) AS revenue_percentage
    FROM customer_type_sales
)
SELECT
    customer_type,
    revenue,
    total_revenue,
    revenue_percentage
FROM revenue_analysis
ORDER BY revenue DESC;    



WITH ranked_transactions AS (
    SELECT
        customer_id,
        product_name,
        sale_date,
        total_amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY sale_date DESC
        ) AS row_num
    FROM flourmills_sales
)
SELECT
    customer_id,
    product_name,
    sale_date,
    total_amount
FROM ranked_transactions
WHERE row_num = 1
ORDER BY customer_id ASC;



WITH RECURSIVE date_range AS (
    SELECT
        MIN(sale_date)::DATE AS start_date,
        MAX(sale_date)::DATE AS end_date
    FROM flourmills_sales
),
all_dates AS (
    SELECT start_date AS sale_date
    FROM date_range
    WHERE start_date IS NOT NULL

    UNION ALL

    SELECT (ad.sale_date + INTERVAL '1 day')::DATE
    FROM all_dates ad
    CROSS JOIN date_range dr
    WHERE ad.sale_date < dr.end_date
)
SELECT sale_date
FROM all_dates
ORDER BY sale_date ASC;





WITH RECURSIVE monthly_revenue AS (
    -- Krok 1: Mesačný súhrn predaja
    SELECT
        DATE_TRUNC('month', sale_date)::DATE AS month,
        SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY DATE_TRUNC('month', sale_date)
),
ordered_months AS (
    -- Krok 2: Očíslovanie mesiacov
    SELECT
        ROW_NUMBER() OVER (ORDER BY month) AS rn,
        month,
        revenue
    FROM monthly_revenue
),
cumulative_target AS (
    -- Krok 3: Začiatok rekurzie – prvý mesiac
    SELECT
        rn,
        month,
        revenue,
        revenue AS cumulative_revenue
    FROM ordered_months
    WHERE rn = 1

    UNION ALL
    SELECT
        next.rn,
        next.month,
        next.revenue,
        current.cumulative_revenue + next.revenue AS cumulative_revenue
    FROM cumulative_target current
    JOIN ordered_months next
        ON next.rn = current.rn + 1
    WHERE current.cumulative_revenue < 500000000
)
SELECT
    month,
    revenue,
    cumulative_revenue
FROM cumulative_target
WHERE cumulative_revenue >= 500000000
ORDER BY rn
LIMIT 1;